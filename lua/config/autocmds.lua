-- ~/.config/nvim/lua/config/autocmds.lua

-- ===========================
-- Helpers
-- ===========================
local function is_ssh()
  return vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil
end

local function opened_with_file_args()
  if vim.fn.argc() == 0 then
    return false
  end
  local a0 = vim.fn.argv(0)
  if a0 ~= "" and vim.fn.isdirectory(a0) == 1 then
    return false
  end
  return true
end

local function buf_valid(bufnr)
  return type(bufnr) == "number" and vim.api.nvim_buf_is_valid(bufnr)
end

local function win_valid(winid)
  return type(winid) == "number" and vim.api.nvim_win_is_valid(winid)
end

local function safe_set_current_win(winid)
  if win_valid(winid) then
    pcall(vim.api.nvim_set_current_win, winid)
    return true
  end
  return false
end

local function is_real_file_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not buf_valid(bufnr) then
    return false
  end

  local ok_bt, bt = pcall(function()
    return vim.bo[bufnr].buftype
  end)
  if not ok_bt or bt ~= "" then
    return false
  end

  local ok_ft, ft = pcall(function()
    return vim.bo[bufnr].filetype
  end)
  if not ok_ft or ft == "" then
    return false
  end

  local blocked = {
    ["neo-tree"] = true,
    ["Outline"] = true,
    ["outline"] = true,
    ["snacks_dashboard"] = true,
    ["snacks_explorer"] = true,
    ["snacks-explorer"] = true,
    ["dashboard"] = true,
    ["alpha"] = true,
    ["NvimTree"] = true,
    ["lazy"] = true,
    ["mason"] = true,
    ["help"] = true,
    ["TelescopePrompt"] = true,
    ["qf"] = true,
    ["Trouble"] = true,
    ["trouble"] = true,
    ["terminal"] = true,
    ["toggleterm"] = true,
    ["dap-repl"] = true,
    ["dapui_scopes"] = true,
    ["dapui_breakpoints"] = true,
    ["dapui_stacks"] = true,
    ["dapui_watches"] = true,
    ["dapui_console"] = true,
    ["dapui_hover"] = true,
    ["Avante"] = true,
    ["AvanteInput"] = true,
    ["AvanteSelectedFiles"] = true,
    ["avante"] = true,
  }

  return not blocked[ft]
end

local function find_win_by_ft(fts)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(w) then
      local ok_b, b = pcall(vim.api.nvim_win_get_buf, w)
      if ok_b and buf_valid(b) then
        local ok_ft, ft = pcall(function()
          return vim.bo[b].filetype
        end)
        if ok_ft then
          for _, want in ipairs(fts) do
            if ft == want then
              return w
            end
          end
        end
      end
    end
  end
  return nil
end

local function find_win_by_buftype(want_bt)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(w) then
      local ok_b, b = pcall(vim.api.nvim_win_get_buf, w)
      if ok_b and buf_valid(b) then
        local ok_bt, bt = pcall(function()
          return vim.bo[b].buftype
        end)
        if ok_bt and bt == want_bt then
          return w
        end
      end
    end
  end
  return nil
end

local function find_real_file_win()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(w) then
      local ok_b, b = pcall(vim.api.nvim_win_get_buf, w)
      if ok_b and buf_valid(b) and is_real_file_buffer(b) then
        return w
      end
    end
  end
  return nil
end

local function find_explorer_win()
  local w = find_win_by_ft({ "neo-tree", "snacks_explorer", "snacks-explorer" })
  if w then return w end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(win) then
      local ok_b, b = pcall(vim.api.nvim_win_get_buf, win)
      if ok_b and buf_valid(b) then
        local ok_bt, bt = pcall(function() return vim.bo[b].buftype end)
        local ok_ft, ft = pcall(function() return vim.bo[b].filetype end)
        local name = vim.api.nvim_buf_get_name(b) or ""
        bt = ok_bt and bt or ""
        ft = ok_ft and ft or ""

        if bt == "nofile" then
          local lower_name = string.lower(name)
          local lower_ft = string.lower(ft)
          if lower_name:find("explorer", 1, true) or lower_ft:find("explorer", 1, true) then
            return win
          end
        end
      end
    end
  end
  return nil
end

-- ===========================
-- Bottom panel helpers
-- ===========================
local function is_bottom_panel_win(win)
  if not win_valid(win) then return false end
  local ok_b, b = pcall(vim.api.nvim_win_get_buf, win)
  if not ok_b or not buf_valid(b) then return false end

  local ok_bt, bt = pcall(function() return vim.bo[b].buftype end)
  local ok_ft, ft = pcall(function() return vim.bo[b].filetype end)
  bt = ok_bt and bt or ""
  ft = ok_ft and ft or ""

  if bt == "terminal" or bt == "quickfix" then return true end

  local bottom_fts = {
    ["qf"] = true, ["Trouble"] = true, ["trouble"] = true,
    ["toggleterm"] = true, ["dap-repl"] = true, ["dapui_console"] = true,
  }
  return bottom_fts[ft] == true
end

local function normalize_bottom_panels_height(target_height)
  target_height = target_height or 12

  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if is_bottom_panel_win(w) then
      pcall(vim.api.nvim_win_set_height, w, target_height)
      pcall(function()
        vim.api.nvim_set_option_value("winfixheight", true, { win = w })
      end)
    end
  end
end

local function ensure_terminal_in_code_area()
  local term_win = find_win_by_buftype("terminal")
  if term_win and win_valid(term_win) then
    pcall(vim.api.nvim_win_set_height, term_win, 12)
    pcall(function()
      vim.api.nvim_set_current_win(term_win)
      vim.wo.winfixheight = true
    end)
    return true
  end

  local code_win = find_real_file_win()
  if not code_win or not win_valid(code_win) then return false end

  local cur_win = vim.api.nvim_get_current_win()
  safe_set_current_win(code_win)

  local ok_split = pcall(vim.cmd, "belowright split")
  if not ok_split then
    if win_valid(cur_win) then safe_set_current_win(cur_win) end
    return false
  end

  pcall(vim.cmd, "resize 12")
  local ok_term = pcall(vim.cmd, "terminal")

  pcall(function() vim.wo.winfixheight = true end)

  if win_valid(code_win) then
    safe_set_current_win(code_win)
  elseif win_valid(cur_win) then
    safe_set_current_win(cur_win)
  end

  return ok_term
end

-- ===========================
-- Sidebar open helpers
-- ===========================
local function open_explorer_safely()
  if find_explorer_win() then return end
  pcall(vim.cmd, "Neotree show left")
end

local function open_outline_safely()
  if find_win_by_ft({ "Outline", "outline" }) then return end
  pcall(vim.cmd, "OutlineOpen")
  if not find_win_by_ft({ "Outline", "outline" }) then
    pcall(vim.cmd, "Outline")
  end
end

-- ===========================
-- General autocmds
-- ===========================
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
    if is_ssh() and vim.v.event.operator == "y" then
      local ok, osc52 = pcall(require, "osc52")
      if ok then
        local reg = vim.v.event.regname
        if reg == "" or reg == "+" or reg == "*" then
          osc52.copy_register(reg == "" and "+" or reg)
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then pcall(vim.cmd, "checktime") end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.bo.modifiable or vim.bo.readonly then return end
    local ft = vim.bo.filetype
    if ft ~= "markdown" and ft ~= "gitcommit" and ft ~= "helm" and ft ~= "make" then
      local view = vim.fn.winsaveview()
      pcall(vim.cmd, [[%s/\s\+$//e]])
      pcall(vim.fn.winrestview, view)
    end
  end,
})

vim.schedule(function()
  pcall(vim.cmd, "echo ''")
  pcall(vim.cmd, "redraw!")
end)

-- ============================================================
-- VSCode-like Default Layout (robust)
--   Left column:   Explorer
--   Middle column: Code (top) + Bottom panel (Terminal)
--   Right column:  Outline
-- ============================================================

local did_layout = false
local layout_running = false
local layout_attempted = false

local function apply_default_layout_once()
  if did_layout then return true end

  local original_win = vim.api.nvim_get_current_win()

  local function restore_focus()
    if win_valid(original_win) then
      safe_set_current_win(original_win)
      return
    end
    local code_win = find_real_file_win()
    if code_win and win_valid(code_win) then
      safe_set_current_win(code_win)
    end
  end

  local code_precheck = find_real_file_win()
  if not code_precheck then
    restore_focus()
    return false
  end

  open_explorer_safely()
  open_outline_safely()

  local explorer_win = find_explorer_win()
  local outline_win = find_win_by_ft({ "Outline", "outline" })

  -- 1) Explorer 왼쪽 위 고정 (폭 40)
  if explorer_win and win_valid(explorer_win) then
    safe_set_current_win(explorer_win)
    pcall(vim.cmd, "wincmd H")
    pcall(vim.cmd, "vertical resize 40")
    pcall(function() vim.wo.winfixwidth = true end)
  end

  -- 2) Outline 오른쪽 끝 고정 (wincmd L)
  if outline_win and win_valid(outline_win) then
    safe_set_current_win(outline_win)
    pcall(vim.cmd, "wincmd L") -- 화면 가장 오른쪽으로 배치
    pcall(vim.cmd, "vertical resize 35") -- 폭 35
    pcall(function() vim.wo.winfixwidth = true end)
  end

  -- 3) 중앙의 코드 영역 아래에만 터미널 띄우기
  ensure_terminal_in_code_area()

  -- 4) 하단 패널 높이 정리
  normalize_bottom_panels_height(12)

  did_layout = true
  restore_focus()
  return true
end

local function apply_layout_with_retries()
  if did_layout or layout_running then return end
  layout_running = true

  local tries = 0
  local function step()
    if did_layout then
      layout_running = false
      return
    end
    tries = tries + 1
    local ok = apply_default_layout_once()
    if ok then
      layout_running = false
      return
    end
    if tries < 3 then
      vim.defer_fn(step, 120)
    else
      layout_running = false
    end
  end
  step()
end

local function maybe_apply_layout(args)
  if did_layout or layout_running or layout_attempted then return end
  if opened_with_file_args() then return end
  if not (args and args.buf) then return end

  vim.schedule(function()
    if did_layout or layout_running or layout_attempted then return end

    local bufnr = args.buf
    if not buf_valid(bufnr) then return end
    if not is_real_file_buffer(bufnr) then return end

    layout_attempted = true
    apply_layout_with_retries()
  end)
end

-- ===========================
-- Layout autocmds
-- ===========================
local layout_group = vim.api.nvim_create_augroup("UserDefaultLayout", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = layout_group,
  callback = function(args)
    maybe_apply_layout(args)
  end,
})

vim.api.nvim_create_autocmd({ "WinNew", "BufWinEnter" }, {
  group = layout_group,
  callback = function()
    if did_layout then
      vim.schedule(function()
        normalize_bottom_panels_height(12)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = layout_group,
  callback = function()
    if did_layout then
      vim.schedule(function()
        normalize_bottom_panels_height(12)
      end)
    end
  end,
})

vim.api.nvim_create_user_command("LayoutDefault", function()
  did_layout = false
  layout_running = false
  layout_attempted = false
  apply_layout_with_retries()
end, {})

vim.api.nvim_create_user_command("LayoutBottomPanels", function()
  normalize_bottom_panels_height(12)
end, {})

-- ===========================
-- Obsidian Window Aesthetics (Purple Border)
-- ===========================
local obsidian_color_group = vim.api.nvim_create_augroup("ObsidianWindowAesthetics", { clear = true })

-- 하이라이트 그룹 정의
vim.api.nvim_set_hl(0, "ObsidianWinSeparator", { fg = "#bb9af7", bold = true })
-- 글로벌 상태바 상단 경계선 (네이티브 overline 방식)
-- Neovim 버전/빌드에 따라 overline 키가 에러를 유발할 수 있어 pcall로 감쌈
pcall(function()
  vim.api.nvim_set_hl(0, "StatusLine", { overline = true, sp = "#00e5ff" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { overline = true, sp = "#00e5ff" })
end)

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FocusGained" }, {
  group = obsidian_color_group,
  callback = function()
    -- colorful-winsep 플러그인과 레이싱을 피하기 위해 schedule 사용
    vim.schedule(function()
      local ok_w, win = pcall(vim.api.nvim_get_current_win)
      if not ok_w or not win_valid(win) then return end
      
      local ok_b, bufnr = pcall(vim.api.nvim_win_get_buf, win)
      if not ok_b or not buf_valid(bufnr) then return end
      
      local name = vim.api.nvim_buf_get_name(bufnr)
      local safe_name = name:gsub("\\", "/")
      
      -- Oil 프로토콜 및 일반 경로 대응
      local is_obsidian = safe_name:find("/10_Projects/") or 
                          safe_name:find("/40_Archive/") or
                          safe_name:find("oil://.*/10_Projects/") or
                          safe_name:find("oil://.*/40_Archive/")

      if is_obsidian then
        -- 1. 글로벌 ColorfulWinsep 색상 변경 (Active Border 색상 테마)
        pcall(vim.api.nvim_set_hl, 0, "ColorfulWinsep", { fg = "#bb9af7", bold = true }) 
        -- 2. 상태바 상단 overline 색상 동기화 (Purple)
        pcall(vim.api.nvim_set_hl, 0, "StatusLine", { overline = true, sp = "#bb9af7" })
        pcall(vim.api.nvim_set_hl, 0, "StatusLineNC", { overline = true, sp = "#bb9af7" })
        -- 3. 현재 창의 WinSeparator 하이라이트 덮어쓰기
        pcall(vim.api.nvim_set_option_value, "winhl", "WinSeparator:ObsidianWinSeparator", { win = win })
      else
        -- 기본 색상 (Cyan / TokyoNight 스타일)
        pcall(vim.api.nvim_set_hl, 0, "ColorfulWinsep", { fg = "#00e5ff", bold = true })
        -- 상태바 상단 overline 색상 동기화 (Cyan)
        pcall(vim.api.nvim_set_hl, 0, "StatusLine", { overline = true, sp = "#00e5ff" })
        pcall(vim.api.nvim_set_hl, 0, "StatusLineNC", { overline = true, sp = "#00e5ff" })
        
        -- 만약 Obsidian 전용 하이라이트가 걸려있다면 제거
        local r_ok, curr_winhl = pcall(vim.api.nvim_get_option_value, "winhl", { win = win })
        if r_ok and curr_winhl and curr_winhl:find("ObsidianWinSeparator") then
          pcall(vim.api.nvim_set_option_value, "winhl", "", { win = win })
        end
      end
    end)
  end,
})

-- ===========================
-- Obsidian Project Auto-Sync
-- ===========================
local obsidian_sync_group = vim.api.nvim_create_augroup("ObsidianProjectSync", { clear = true })

local function sync_obsidian_status()
  local ok, obs = pcall(require, "core.obsidian_project")
  if not ok then return end
  
  local project_name, status = obs.get_current_project_info()
  if not project_name then return end
  
  local act_dir, arc_dir = obs.get_obsidian_dirs()
  local target_obsidian_path = (status == "archive" and arc_dir or act_dir) .. "/" .. project_name
  local opposite_obsidian_path = (status == "archive" and act_dir or arc_dir) .. "/" .. project_name

  -- 만약 반대편 (예: 10_Projects) 에 폴더가 여전히 있다면 타겟 (예: 40_Archive) 으로 자동 이동
  if vim.fn.isdirectory(opposite_obsidian_path) == 1 then
    -- 타겟 부모 폴더 보장
    vim.fn.mkdir(status == "archive" and arc_dir or act_dir, "p")
    local cmd = string.format("mv '%s' '%s'", opposite_obsidian_path, target_obsidian_path)
    vim.fn.system(cmd)
    
    local icon = status == "archive" and "📦" or "🚀"
    local dir_name = status == "archive" and "40_Archive" or "10_Projects"
    
    vim.notify(
      string.format("Obsidian 노트가 상태에 맞게 동기화되었습니다.\n%s -> %s", project_name, dir_name), 
      vim.log.levels.INFO, 
      { title = icon .. " Obsidian Sync" }
    )
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = obsidian_sync_group,
  callback = function()
    -- VimEnter 시점의 지연을 막기 위해 schedule 사용
    vim.schedule(sync_obsidian_status)
  end,
})