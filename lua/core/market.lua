-- lua/core/market.lua
local M = {}

local state = {
  KOSPI       = { val = "loading...", raw = 0 },
  KOSDAQ      = { val = "loading...", raw = 0 },
  NASDAQ      = { val = "loading...", raw = 0 },
  ["S&P 500"] = { val = "loading...", raw = 0 },
  USDKRW      = { val = "loading...", raw = 0 },
  BTC         = { val = "loading...", raw = 0 },
  ETH         = { val = "loading...", raw = 0 },
}

local win = nil
local buf = nil

local order = {
  { key = "KOSPI",   ticker = "^KS11",  type = "yahoo", url = "https://finance.yahoo.com/quote/%5EKS11" },
  { key = "KOSDAQ",  ticker = "^KQ11",  type = "yahoo", url = "https://finance.yahoo.com/quote/%5EKQ11" },
  { key = "NASDAQ",  ticker = "^IXIC",  type = "yahoo", url = "https://finance.yahoo.com/quote/%5EIXIC" },
  { key = "S&P 500", ticker = "^GSPC",  type = "yahoo", url = "https://finance.yahoo.com/quote/%5EGSPC" },
  { key = "USDKRW",  ticker = "KRW=X",  type = "yahoo", url = "https://finance.yahoo.com/quote/KRW=X" },
  { key = "BTC",     ticker = "BTCUSDT",type = "binance", url = "https://www.binance.com/en/trade/BTC_USDT" },
  { key = "ETH",     ticker = "ETHUSDT",type = "binance", url = "https://www.binance.com/en/trade/ETH_USDT" },
}

local ns = vim.api.nvim_create_namespace("MarketWatcher")

local function fmt(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function render()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  
  vim.bo[buf].modifiable = true
  local lines = {}
  for _, item in ipairs(order) do
    local text = string.format(" %-9s %s", item.key, state[item.key].val)
    table.insert(lines, text)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- 하이라이트 적용 (색상 입히기)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for i, item in ipairs(order) do
    local val = state[item.key].val
    if val:find("↑") then
      vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticOk", i-1, 0, -1)
    elseif val:find("↓") then
      vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticError", i-1, 0, -1)
    else
      vim.api.nvim_buf_add_highlight(buf, ns, "Comment", i-1, 0, -1)
    end
    -- 레이블(종목명)은 굵고 흰색으로 표시
    vim.api.nvim_buf_add_highlight(buf, ns, "Title", i-1, 0, 11)
  end
  
  vim.bo[buf].modifiable = false
end

local function run_job(cmd, cb)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then cb(table.concat(data, "")) end
    end
  })
end

local function fetch_yahoo(item)
  local cmd = {
    "curl", "-sf", "--connect-timeout", "3", "-A", "Mozilla/5.0",
    "https://query1.finance.yahoo.com/v8/finance/chart/" .. item.ticker .. "?interval=1d&range=1d"
  }
  run_job(cmd, function(body)
    if not body or body == "" then state[item.key].val = "N/A"; render(); return end
    local price = body:match('"regularMarketPrice":([%d%.]+)')
    local prev  = body:match('"chartPreviousClose":([%d%.]+)')
    
    if price and prev then
      local p = tonumber(price)
      local pv = tonumber(prev)
      local cv = ((p - pv) / pv) * 100
      local arrow = cv >= 0 and "↑" or "↓"
      
      -- USD 환율은 소수점을 유지, 지수는 포맷 적용
      local p_str = (item.key == "USDKRW") and string.format("%.2f", p) or fmt(p)
      state[item.key].val = string.format("%10s   %s%.2f%%", p_str, arrow, math.abs(cv))
    else
      state[item.key].val = "N/A"
    end
    render()
  end)
end

local function fetch_binance(item)
  local cmd = {
    "curl", "-sf", "--connect-timeout", "3",
    "https://api.binance.com/api/v3/ticker/24hr?symbol=" .. item.ticker
  }
  run_job(cmd, function(body)
    if not body or body == "" then state[item.key].val = "N/A"; render(); return end
    local price = body:match('"lastPrice":"([%d%.]+)"')
    local chg   = body:match('"priceChangePercent":"(-?[%d%.]+)"')
    if price then
      local cv    = tonumber(chg) or 0
      local arrow = cv >= 0 and "↑" or "↓"
      state[item.key].val = string.format("%10s   %s%.2f%%", fmt(tonumber(price)), arrow, math.abs(cv))
    else
      state[item.key].val = "N/A"
    end
    render()
  end)
end

function M.refresh()
  for _, item in ipairs(order) do
    state[item.key].val = "loading..."
    if item.type == "yahoo" then
      fetch_yahoo(item)
    elseif item.type == "binance" then
      fetch_binance(item)
    end
  end
  render()
end

function M.toggle()
  -- 창이 띄워져 있다면 닫기
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
    buf = nil
    return
  end
  
  -- 새 버퍼 생성
  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "MarketWatcher"
  
  local width = 36
  local height = #order
  
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    title = " 📈 Market Watcher ",
    title_pos = "center"
  }
  
  win = vim.api.nvim_open_win(buf, true, opts)
  
  -- 선택적 투명도
  pcall(vim.api.nvim_set_option_value, "winblend", 10, { win = win })
  vim.api.nvim_set_option_value("cursorline", true, { win = win })
  
  -- 버퍼 로컬 키맵 주입
  local map_opts = { buffer = buf, silent = true }
  
  -- 닫기
  vim.keymap.set("n", "q", function() M.toggle() end, map_opts)
  vim.keymap.set("n", "<Leader>M", function() M.toggle() end, map_opts)
  vim.keymap.set("n", "<Esc>", function() M.toggle() end, map_opts)
  
  -- 새로고침
  vim.keymap.set("n", "r", function() M.refresh() end, map_opts)
  
  -- 웹 링크 열기
  vim.keymap.set("n", "<CR>", function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line = cursor[1]
    local url = order[line].url
    if vim.fn.executable("open") == 1 then
      vim.fn.system({"open", url})
      vim.notify("🌐 Opened " .. order[line].key .. " chart in browser.", vim.log.levels.INFO)
    else
      vim.notify("URL 오픈은 macOS의 'open' 명령어에 의존합니다.", vim.log.levels.WARN)
    end
  end, map_opts)
  
  -- 최초 데이터 수집 시작
  M.refresh()
end

return M
