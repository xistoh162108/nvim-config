-- lua/core/metrics.lua
-- 비동기로 시스템 지표를 수집하고
-- ~/.cache/nvim/nvim-metrics.txt 에 ANSI 컬러 위젯을 기록한다.

local M  = {}
local uv = vim.uv or vim.loop

M.cache = vim.fn.stdpath("cache") .. "/nvim-metrics.txt"

-- ── 기본 상태 (로딩 전 표시값) ─────────────────────────────
M.state = {
  ram     = "loading…",
  swap    = "loading…",
  battery = "loading…",
  disk    = "loading…",
  cpu     = "loading…",
  ip      = "fetching…",
  qos     = "pinging…",
  docker  = "scanning…",
  ollama  = "scanning…",
  ports   = "scanning…",
}

-- ── ANSI 팔레트 ────────────────────────────────────────────
local A = {
  c = "\27[36m",   -- cyan    → 시스템 레이블
  g = "\27[32m",   -- green   → 정상
  y = "\27[33m",   -- yellow  → 하드웨어 레이블
  r = "\27[31m",   -- red     → 경고/위험
  m = "\27[35m",   -- magenta → 인프라
  o = "\27[38;5;208m", -- orange → Poor
  d = "\27[2m",    -- dim
  z = "\27[0m",    -- reset
}
local function c(color, s) return color .. s .. A.z end

-- ── 동기 수집 (즉시) ───────────────────────────────────────
local function read_ram()
  local lines = vim.fn.systemlist("vm_stat 2>/dev/null")
  if not lines or #lines == 0 then return "N/A" end
  
  -- Apple Silicon은 16384, Intel은 4096. 하드웨어에서 직접 페이지 사이즈를 가져온다
  local ps_out = vim.fn.system("pagesize 2>/dev/null")
  local ps = tonumber(ps_out) or 4096
  
  local free, active, inactive, wired, comp = 0, 0, 0, 0, 0
  for _, l in ipairs(lines) do
    local n = tonumber(l:match(":%s*(%d+)%.?"))
    if     l:find("Pages free")                   then free     = n or 0
    elseif l:find("Pages active")                 then active   = n or 0
    elseif l:find("Pages inactive")               then inactive = n or 0
    elseif l:find("Pages wired")                  then wired    = n or 0
    elseif l:find("Pages occupied by compressor") then comp     = n or 0
    end
  end
  local used = (active + wired + comp) * ps / (1024 ^ 3)
  
  local hw_mem = vim.fn.system("sysctl -n hw.memsize 2>/dev/null")
  local total = hw_mem and (tonumber(hw_mem) / (1024^3)) or ((free + active + inactive + wired + comp) * ps / (1024 ^ 3))
  
  return string.format("%.1f / %.0f GB", used, total)
end

local function read_swap()
  local out = vim.fn.system("sysctl -n vm.swapusage 2>/dev/null")
  if not out or out == "" then return "N/A" end
  local total, used = out:match("total = ([%d%.]+)M%s+used = ([%d%.]+)M")
  if total and used then
    return string.format("%.1f / %.1f GB", tonumber(used) / 1024, tonumber(total) / 1024)
  end
  return out:match("used = (%S+)") or "N/A"
end

local function read_battery()
  local lines = vim.fn.systemlist("pmset -g batt 2>/dev/null")
  if not lines or #lines < 2 then return "N/A" end
  local pct   = lines[2]:match("(%d+)%%")
  local arrow = lines[2]:match("discharging") and "↓"
             or lines[2]:match("charging")    and "↑" or "="
  return pct and (pct .. "% " .. arrow) or "N/A"
end

local function read_disk()
  local out = vim.fn.systemlist("df -h /System/Volumes/Data 2>/dev/null")
  if not out or #out < 2 then
    out = vim.fn.systemlist("df -h / 2>/dev/null") -- Fallback if not macOS
  end
  if not out or #out < 2 then return "N/A" end
  local size, used, avail, pct = out[2]:match("(%S+)%s+(%S+)%s+(%S+)%s+(%d+%%)")
  if size and used and pct then
    return string.format("%s / %s (%s)", used, size, pct)
  end
  return "N/A"
end

local function read_cpu_load()
  -- LoadAvg 대신 실제 점유율(%)을 코어 수로 나누어 0~100% 로 환산
  local script = [[ cores=$(sysctl -n hw.logicalcpu 2>/dev/null || echo 1); ps -A -o %cpu | awk -v c="$cores" '{s+=$1} END {printf "%.1f%%", s/c}' ]]
  local out = vim.fn.system(script)
  if not out or out == "" then return "N/A" end
  return out:gsub("\n", "")
end

local function fmt(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- ── 비동기 잡 헬퍼 ─────────────────────────────────────────
local pending  = 0
local _on_done = nil

local function tick()
  pending = pending - 1
  if pending <= 0 and _on_done then
    vim.schedule(_on_done)
  end
end

local function run(cmd, cb)
  pending = pending + 1
  local out = {}
  local ok = pcall(vim.fn.jobstart, cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      for _, l in ipairs(data) do
        if l ~= "" then table.insert(out, l) end
      end
    end,
    on_exit = function(_, code)
      pcall(cb, code == 0 and out or nil)
      tick()
    end,
  })
  if not ok then tick() end
end

-- ── 비동기 수집 함수들 ─────────────────────────────────────
local function update_dash()
  vim.schedule(function()
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.dashboard then pcall(snacks.dashboard.update) end
  end)
end

local function fetch_docker()
  run({ "docker", "ps", "-q" }, function(o)
    M.state.docker = o and (#o .. " container" .. (#o == 1 and "" or "s")) or "N/A"
    update_dash()
  end)
end

local function fetch_ollama()
  run({ "curl", "-sf", "--connect-timeout", "1", "http://localhost:11434" }, function(o)
    M.state.ollama = o and "✓ online" or "✗ off"
    update_dash()
  end)
end

local function fetch_ports()
  run({ "sh", "-c",
    "lsof -iTCP -sTCP:LISTEN -Pn 2>/dev/null"
    .. " | awk 'NR>1{print $9}'"
    .. " | grep -oE '[0-9]+$' | sort -un | head -10 | tr '\n' ' '"
  }, function(o)
    M.state.ports = (o and #o > 0)
      and table.concat(o, " "):gsub("%s+$", "")
      or  "none"
    update_dash()
  end)
end

local function calc_stability(l, j, p)
  local p_l = math.min(40, math.max(0, l - 20) * 0.5)
  local p_j = math.min(30, math.max(0, j - 2) * 2)
  local p_p = math.min(30, p * 15)
  local score = 100 - p_l - p_j - p_p

  if p >= 2 or j >= 30 or l >= 150 then
    return "Bad", A.r
  end

  if score >= 90 then return "Excellent", A.g
  elseif score >= 75 then return "Good", A.c
  elseif score >= 60 then return "Fair", A.y
  elseif score >= 40 then return "Poor", A.o
  else return "Bad", A.r end
end

local function fetch_network()
  local script = [[
    ip=$(curl -s --connect-timeout 2 ifconfig.me || echo "offline")
    iface=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')
    [ -z "$iface" ] && iface="none"
    echo "IPSTR: $ip ($iface)"
    ping -c 4 -i 0.2 -q 8.8.8.8 2>/dev/null
  ]]
  run({ "sh", "-c", script }, function(out)
    if not out or #out == 0 then
      M.state.ip = "offline"
      M.state.qos = "N/A"
      update_dash()
      return
    end

    local body = table.concat(out, "\n")
    local ip_str = body:match("IPSTR:%s*([^\n]+)")
    if ip_str then M.state.ip = ip_str end

    local loss = body:match("(%d+%.?%d*)%%%s*packet loss")
    local min, avg, max, stddev = body:match("round%-trip min/avg/max/stddev = ([%d%.]+)/([%d%.]+)/([%d%.]+)/([%d%.]+)")

    if loss and avg and stddev then
      local n_loss = tonumber(loss) or 0
      local n_lat = tonumber(avg) or 0
      local n_jit = tonumber(stddev) or 0
      local grade, color = calc_stability(n_lat, n_jit, n_loss)
      
      M.state.qos = string.format("%s %dms, %.1fjit", grade, n_lat, n_jit)
    else
      M.state.qos = "N/A"
    end
    update_dash()
  end)
end

-- ── Snacks Native 렌더링 함수 ──────────────────────────────
function M.snacks_lines()
  local s = M.state
  local sep = { { "  " .. string.rep("─", 65), "SnacksDashboardDir" } }

  -- 레이블: 특정 하이라이트 그룹 지정 후 총 9칸 차지
  local function lbl(hl, t)
    local pad = string.rep(" ", 9 - vim.fn.strdisplaywidth(t))
    return { "  " .. t .. pad, hl }
  end

  -- 값 패딩: 주어진 너비만큼 정확하게 채움
  local function val(v, width, hl)
    local visible_text = tostring(v)
    local len = vim.fn.strdisplaywidth(visible_text)
    if len > width then 
      visible_text = visible_text:sub(1, width - 1) .. "…"
      len = width
    end
    local pad = string.rep(" ", width - len)
    return { visible_text .. pad, hl or "Normal" }
  end
  
  -- QoS 색상 파싱 (Excellent, Good 등)
  local function qos_val(v, width)
    local visible_text = tostring(v)
    local hl = "Normal"
    if visible_text:find("Excellent") then hl = "DiagnosticOk"
    elseif visible_text:find("Good") then hl = "DiagnosticInfo"
    elseif visible_text:find("Fair") then hl = "DiagnosticWarn"
    elseif visible_text:find("Poor") then hl = "DiagnosticWarn"  
    elseif visible_text:find("Bad") then hl = "DiagnosticError"
    end
    
    local len = vim.fn.strdisplaywidth(visible_text)
    if len > width then 
      visible_text = visible_text:sub(1, width - 1) .. "…"
      len = width
    end
    local pad = string.rep(" ", width - len)
    return { visible_text .. pad, hl }
  end

  -- 모든 라인은 "2칸 여백" + 9 + 25 + 9 + 22 = 67칸 너비를 가져야 정렬이 맞음
  return {
    { text = sep },
    { text = { lbl("DiagnosticInfo", "RAM"),    val(s.ram, 25),      lbl("DiagnosticWarn", "CPU"),  val(s.cpu, 22) } },
    { text = { lbl("DiagnosticInfo", "Swap"),   val(s.swap, 25),     lbl("DiagnosticWarn", "Disk"), val(s.disk, 22) } },
    { text = { lbl("DiagnosticInfo", "Batt"),   val(s.battery, 25),  lbl("DiagnosticWarn", "IPv4"), val(s.ip, 22) } },
    { text = { lbl("DiagnosticHint", "Docker"), val(s.docker, 25),   lbl("DiagnosticWarn", "QoS"),  qos_val(s.qos, 22) } },
    { text = sep },
    { text = { lbl("DiagnosticHint", "Ollama"), val(s.ollama, 56) } },
    { text = { lbl("DiagnosticHint", "Ports"),  val(s.ports, 56) } },
    { text = sep },
  }
end

-- ── 공개 API ───────────────────────────────────────────────
function M.init(on_done)
  M.state.ram     = read_ram()
  M.state.swap    = read_swap()
  M.state.battery = read_battery()
  M.state.disk    = read_disk()
  M.state.cpu     = read_cpu_load()

  if on_done then vim.schedule(on_done) end

  _on_done = function()
    local ok_snacks, snacks = pcall(require, "snacks")
    if ok_snacks and snacks.dashboard then
      snacks.dashboard.update()
    end
  end

  fetch_docker()
  fetch_ollama()
  fetch_ports()
  fetch_network()

  -- 실시간 업데이트용 타이머 (1초 간격)
  if M.timer then
    M.timer:stop()
    M.timer:close()
  end
  
  M.timer = uv.new_timer()
  M.timer:start(1000, 1000, function()
    vim.schedule(function()
      M.state.ram     = read_ram()
      M.state.swap    = read_swap()
      M.state.battery = read_battery()
      M.state.cpu     = read_cpu_load()
      M.state.disk    = read_disk()
      
      update_dash()
    end)
  end)
end

return M
