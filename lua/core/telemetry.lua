-- lua/core/telemetry.lua
-- 키맵 & Ex 커맨드 사용 통계를 수집해 JSON 으로 저장한다.
--
-- 수집 대상:
--   · Normal/Visual 모드에서 leader(<Space>+), g, c/d/y/z, Ctrl, [/] 조합키
--   · ':' 로 실행된 Ex 커맨드
--
-- 저장: 5분 주기 + VimLeave → stdpath('data')/telemetry.json
-- 조회: :TelemetryReport  →  플로팅 윈도우 (Markdown 표)

local M  = {}
local uv = vim.uv or vim.loop

-- ── 경로 ────────────────────────────────────────────────────
local JSON_PATH = vim.fn.stdpath("data") .. "/telemetry.json"

-- ── 런타임 통계 ─────────────────────────────────────────────
local stats = { keys = {}, cmds = {} }

-- ── 영속 데이터 로드 ─────────────────────────────────────────
local function load_stats()
  local f = io.open(JSON_PATH, "r")
  if not f then return end
  local ok, data = pcall(vim.fn.json_decode, f:read("*a"))
  f:close()
  if ok and type(data) == "table" then
    stats.keys = type(data.keys) == "table" and data.keys or {}
    stats.cmds = type(data.cmds) == "table" and data.cmds or {}
  end
end

-- ── 저장 ────────────────────────────────────────────────────
local function save_stats()
  local ok, json = pcall(vim.fn.json_encode, {
    keys     = stats.keys,
    cmds     = stats.cmds,
    saved_at = os.time(),
  })
  if not ok then return end
  local f = io.open(JSON_PATH, "w")
  if f then f:write(json) ; f:close() end
end

-- ── 키 시퀀스 추적 ──────────────────────────────────────────
local TIMEOUT_MS = 600   -- 이 시간(ms) 무입력 시 시퀀스 확정
local MAX_LEN    = 5     -- 시퀀스 최대 길이

local seq      = {}      -- 누적 키 버퍼 (keytrans 결과)
local seq_at   = 0       -- 마지막 키 입력 시각 (uv.now)
local cur_mode = "n"     -- 캐시된 모드 (ModeChanged 갱신)

-- 기록할 가치가 있는 시퀀스 판별
local function is_worthy(s)
  if s:match("^<Space>") then return true end  -- leader 시퀀스
  if s:match("^g[%a%p]") then return true end  -- g-prefix
  if s:match("^[cdyvz][%a%p%%0-9^$]") then return true end  -- operator motions
  if s:match("^<C%-") then return true end     -- Ctrl 조합
  if s:match("^[%[%]][%a%p]") then return true end  -- [x ]x 점프
  return false
end

local function commit()
  if #seq == 0 then return end
  local s = table.concat(seq)
  if is_worthy(s) then
    stats.keys[s] = (stats.keys[s] or 0) + 1
  end
  seq = {}
end

-- 타임아웃 타이머 (마지막 키 입력 후 TIMEOUT_MS 지나면 확정)
local seq_timer = uv.new_timer()

local ns = vim.api.nvim_create_namespace("telemetry_on_key")

vim.on_key(function(key)
  -- Normal / Visual 모드만 추적
  if cur_mode ~= "n" and cur_mode ~= "v" and cur_mode ~= "x" then
    if #seq > 0 then commit() end
    return
  end

  local now = uv.now()

  -- 타임아웃: 오래된 시퀀스 확정
  if #seq > 0 and (now - seq_at) > TIMEOUT_MS then
    commit()
  end
  seq_at = now

  -- 키를 human-readable 로 변환 (예: "\27[A" → "<Up>")
  local ok, k = pcall(vim.fn.keytrans, key)
  if not ok or k == "" then return end

  -- Escape → 시퀀스 취소
  if k == "<Esc>" then
    seq = {}
    seq_timer:stop()
    return
  end

  table.insert(seq, k)

  -- 타이머 재시작
  seq_timer:stop()
  seq_timer:start(TIMEOUT_MS, 0, vim.schedule_wrap(commit))

  -- 최대 길이 도달 시 즉시 확정
  if #seq >= MAX_LEN then
    seq_timer:stop()
    commit()
  end
end, ns)

-- 모드 전환 시 현재 모드 갱신 + 이전 시퀀스 확정
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    cur_mode = vim.api.nvim_get_mode().mode
    if #seq > 0
      and cur_mode ~= "n"
      and cur_mode ~= "v"
      and cur_mode ~= "x"
    then
      commit()
    end
  end,
})

-- Ex 커맨드 추적
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    if vim.fn.getcmdtype() ~= ":" then return end
    local cmd = vim.trim(vim.fn.getcmdline())
    -- 공백·숫자 전용·단순이동 제외
    if cmd ~= "" and not cmd:match("^%d+$") then
      stats.cmds[cmd] = (stats.cmds[cmd] or 0) + 1
    end
  end,
})

-- ── 자동 저장 ────────────────────────────────────────────────
local save_timer = uv.new_timer()
save_timer:start(300000, 300000, vim.schedule_wrap(save_stats))  -- 5분

vim.api.nvim_create_autocmd("VimLeave", { callback = save_stats })

-- ── :TelemetryReport ─────────────────────────────────────────
vim.api.nvim_create_user_command("TelemetryReport", function()
  -- 키 정렬
  local kl = {}
  for k, v in pairs(stats.keys) do table.insert(kl, { key = k, n = v }) end
  table.sort(kl, function(a, b) return a.n > b.n end)

  -- 커맨드 정렬
  local cl = {}
  for k, v in pairs(stats.cmds) do table.insert(cl, { cmd = k, n = v }) end
  table.sort(cl, function(a, b) return a.n > b.n end)

  -- 막대 그래프 헬퍼
  local BAR = 18
  local function bar(n, max)
    local filled = max > 0 and math.floor(n / max * BAR) or 0
    return ("█"):rep(filled) .. ("░"):rep(BAR - filled)
  end

  -- 라인 빌드
  local lines = { "# Keymap Usage — Top 20", "", "| # | Key | Count | Graph |", "|--:|-----|------:|-------|" }
  local kmax  = kl[1] and kl[1].n or 1
  for i, item in ipairs(kl) do
    if i > 20 then break end
    table.insert(lines, string.format("| %2d | `%s` | %d | `%s` |",
      i, item.key, item.n, bar(item.n, kmax)))
  end

  if #cl > 0 then
    local cmax = cl[1].n
    table.insert(lines, "")
    table.insert(lines, "# Ex Commands — Top 15")
    table.insert(lines, "")
    table.insert(lines, "| # | Command | Count | Graph |")
    table.insert(lines, "|--:|---------|------:|-------|")
    for i, item in ipairs(cl) do
      if i > 15 then break end
      table.insert(lines, string.format("| %2d | `%s` | %d | `%s` |",
        i, item.cmd, item.n, bar(item.n, cmax)))
    end
  end

  table.insert(lines, "")
  table.insert(lines, string.format(
    "> %d unique keys · %d unique commands · saved to `%s`",
    #kl, #cl, JSON_PATH))

  -- 플로팅 윈도우
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype   = "markdown"
  vim.bo[buf].modifiable = false

  local W = math.min(72, vim.o.columns - 4)
  local H = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    width     = W,
    height    = H,
    row       = math.floor((vim.o.lines   - H) / 2),
    col       = math.floor((vim.o.columns - W) / 2),
    style     = "minimal",
    border    = "rounded",
    title     = "  Telemetry Report  ",
    title_pos = "center",
  })

  local function close() vim.api.nvim_win_close(win, true) end
  vim.keymap.set("n", "q",     close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
end, { desc = "Show keymap & command usage statistics" })

-- ── 초기화 ──────────────────────────────────────────────────
load_stats()

return M
