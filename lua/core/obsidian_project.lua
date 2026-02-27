-- lua/core/obsidian_project.lua
-- Obsidian 커스텀 기능 (100% 내장 Lua API, 외부 의존성 없음)

local M = {}

local VAULT          = "/Users/bagjimin/Documents/SecondBrain"
local OBSIDIAN_ACT   = VAULT .. "/Notes/10_Projects"
local OBSIDIAN_ARC   = VAULT .. "/Notes/40_Archive"
local CODE_ACT       = "/Users/bagjimin/Documents/1. Projects"
local CODE_ARC       = "/Users/bagjimin/Documents/Archive"

--- 탭별 상태 관리 (Workspace State Machine)
local workspaces = {}

local function get_state()
  local tab = vim.api.nvim_get_current_tabpage()
  if not workspaces[tab] then
    workspaces[tab] = {
      is_active = false,
      explorer_win = nil,
      viewer_win = nil,
      last_preview_buf = nil
    }
  end
  return workspaces[tab]
end

--- 현재 루트 프로젝트 폴더명과 상태, 절대 경로를 추출 (Deep Nesting 대응 및 Strict Bypass)
local function get_project_info()
  local cwd = vim.fn.getcwd()
  local safe_cwd = cwd:gsub("\\", "/")
  
  local function extract(path)
    for _, trig in ipairs({"/1%. Projects/", "/10_Projects/"}) do
      local s, e = path:find(trig)
      if s then
        local p = path:sub(e + 1):match("^([^/]+)")
        if p then return p, "active", CODE_ACT .. "/" .. p end
      end
    end
    for _, trig in ipairs({"/Archive/", "/40_Archive/"}) do
      local s, e = path:find(trig)
      if s then
        local p = path:sub(e + 1):match("^([^/]+)")
        if p then return p, "archive", CODE_ARC .. "/" .. p end
      end
    end
    return nil, nil, nil
  end

  local p, s, c = extract(safe_cwd)
  if p then return p, s, c end
  
  local ok_b, buf_path = pcall(vim.api.nvim_buf_get_name, 0)
  if ok_b and buf_path ~= "" then
    buf_path = buf_path:gsub("\\", "/")
    p, s, c = extract(buf_path)
    if p then return p, s, c end
  end
  
  local ok, util_root = pcall(require, "lazyvim.util")
  if ok and util_root.root then
    local rpath = util_root.root.get():gsub("\\", "/")
    p, s, c = extract(rpath)
    if p then return p, s, c end
  end
  
  return nil, nil, nil
end

local function get_target_obsidian_dir(status)
  if status == "archive" then
    return OBSIDIAN_ARC
  end
  return OBSIDIAN_ACT
end

local function ensure_note(note_path, project_name, code_root_path)
  if vim.fn.filereadable(note_path) == 0 then
    local dir = vim.fn.fnamemodify(note_path, ":h")
    vim.fn.mkdir(dir, "p")
    local f = io.open(note_path, "w")
    if f then
      local created = os.date("%Y-%m-%d %H:%M")
      f:write(string.format([[---
created: %s
tags:
  - project
local_path: "%s"
---

# 🚀 %s

## Overview


## Snippets

]], created, code_root_path, project_name))
      f:close()
    end
  end
end

--------------------------------------------------------------------------------
-- 🚀 V2 Workspace Routing Action
--------------------------------------------------------------------------------
function M.handle_action(action)
  local state = get_state()
  if not state.is_active or not state.explorer_win or not vim.api.nvim_win_is_valid(state.explorer_win) then return end
  
  -- 디렉터리 확인 (oil.nvim)
  local oil_ok, oil = pcall(require, "oil")
  if oil_ok then
    local entry = oil.get_cursor_entry()
    if entry and entry.parsed_name and entry.type == "directory" then
      -- 디렉터리라면 원래 oil의 동작(폴더 진입)을 수행해야 하므로 자체 키를 먹임
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
      return
    end
  end

  -- 파일 경로 획득
  local file_path = oil_ok and oil.get_cursor_entry() and oil.get_cursor_entry().name or nil
  if not file_path then return end
  local full_path = oil.get_current_dir() .. file_path
  
  -- 하단 뷰어 창 검증 및 복구 (Auto-Recovery)
  if not state.viewer_win or not vim.api.nvim_win_is_valid(state.viewer_win) or vim.w[state.viewer_win].obsidian_role ~= "viewer" then
    vim.api.nvim_set_current_win(state.explorer_win)
    vim.cmd("belowright split")
    state.viewer_win = vim.api.nvim_get_current_win()
    vim.w[state.viewer_win].obsidian_role = "viewer"
  end
  
  -- 저장되지 않은 버퍼 방어
  local current_buf = vim.api.nvim_win_get_buf(state.viewer_win)
  if vim.api.nvim_get_option_value("modified", {buf = current_buf}) then
    vim.notify("⚠ 뷰어 창에 저장되지 않은 내용이 있어 백그라운드로 안전하게 숨깁니다.", vim.log.levels.WARN, {title="Obsidian Workspace"})
  end

  -- 미리보기 버퍼 가비지 컬렉션 (버퍼 누수 방지)
  if action == "preview" and state.last_preview_buf and vim.api.nvim_buf_is_valid(state.last_preview_buf) then
    if not vim.api.nvim_get_option_value("modified", {buf = state.last_preview_buf}) then
      -- 강제로 닫지 않고 메모리에서 깔끔하게 해제
      pcall(vim.api.nvim_buf_delete, state.last_preview_buf, {force = false})
    end
  end

  -- 타겟 뷰어 창에서 문서 열기
  vim.api.nvim_set_current_win(state.viewer_win)
  vim.cmd("edit " .. vim.fn.fnameescape(full_path))
  local new_buf = vim.api.nvim_get_current_buf()

  -- 포커스 및 상태 관리
  if action == "preview" then
    state.last_preview_buf = new_buf
    -- 미리보기 모드: 커서를 상단 탐색기로 원복
    vim.api.nvim_set_current_win(state.explorer_win)
  elseif action == "edit" then
    state.last_preview_buf = nil
    -- 편집 모드: 커서를 하단 뷰어로 고정
  end
end

--------------------------------------------------------------------------------
-- 🚀 V2 Workspace Builder / Toggle
--------------------------------------------------------------------------------
function M.open_project_note()
  local state = get_state()
  
  -- Toggle OFF
  if state.is_active then
    state.is_active = false
    if state.explorer_win and vim.api.nvim_win_is_valid(state.explorer_win) then
      pcall(vim.api.nvim_win_close, state.explorer_win, false)
    end
    if state.viewer_win and vim.api.nvim_win_is_valid(state.viewer_win) then
      pcall(vim.api.nvim_win_close, state.viewer_win, false)
    end
    -- 완전한 클린업
    state.explorer_win = nil
    state.viewer_win = nil
    state.last_preview_buf = nil
    return
  end
  
  -- Toggle ON
  local project_name, status, code_root = get_project_info()
  if not project_name then
    vim.notify("🚫 프로젝트 관리 대상 폴더가 아닙니다.", vim.log.levels.WARN, { title = "Obsidian Project" })
    return
  end
  
  local target_dir = get_target_obsidian_dir(status) .. "/" .. project_name
  local note_path = target_dir .. "/" .. project_name .. ".md"
  
  ensure_note(note_path, project_name, code_root)
  
  -- 우측 40컬럼 패널 생성 (Explorer)
  vim.cmd("botright 40vsplit")
  local parent_win = vim.api.nvim_get_current_win()
  
  -- 디렉토리 핸들러 강제 하이재킹 방지 (Snacks.explorer 등이 floating 창으로 가로채는 현상 방어)
  local ok_oil, oil = pcall(require, "oil")
  if ok_oil then
    oil.open(target_dir)
  else
    local ok_cmd = pcall(vim.cmd, "Oil " .. vim.fn.fnameescape(target_dir))
    if not ok_cmd then
      vim.cmd("edit " .. vim.fn.fnameescape(target_dir))
    end
  end
  
  -- 🌟 핵심 보완 1: 상단 창의 width 고정 (비율 유지)
  vim.api.nvim_set_option_value("winfixwidth", true, {win = parent_win})
  
  state.explorer_win = parent_win
  vim.w[state.explorer_win].obsidian_role = "explorer"
  local exp_buf = vim.api.nvim_get_current_buf()
  
  -- 🌟 핵심 보완 2: 버퍼 로컬 키맵 주입 (전역 격리 원칙)
  vim.api.nvim_buf_set_keymap(exp_buf, "n", "<CR>", 
    "<Cmd>lua require('core.obsidian_project').handle_action('edit')<CR>", 
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(exp_buf, "n", "<Tab>", 
    "<Cmd>lua require('core.obsidian_project').handle_action('preview')<CR>", 
    { noremap = true, silent = true })
    
  -- 하단 패널 분할 (Viewer)
  vim.cmd("belowright split " .. vim.fn.fnameescape(note_path))
  local viewer_win = vim.api.nvim_get_current_win()
  state.viewer_win = viewer_win
  vim.w[state.viewer_win].obsidian_role = "viewer"
  
  -- 🌟 핵심 보완 3: 상하 비율 20:80 조정 & height 고정
  local total_height = vim.api.nvim_win_get_height(parent_win) + vim.api.nvim_win_get_height(viewer_win)
  local exp_height = math.floor(total_height * 0.2)
  -- 만약 전체 높이가 너무 작아서 20%가 비정상적으로 작게 잡힌다면 방어
  if exp_height < 5 then exp_height = 5 end
  
  vim.api.nvim_win_set_height(state.explorer_win, exp_height)
  vim.api.nvim_set_option_value("winfixheight", true, {win = state.explorer_win})
  
  state.is_active = true
  
  -- 초기 오프닝 시 커서를 하단(노트 편집) 창에 둠 
  vim.api.nvim_set_current_win(state.viewer_win)
end

-- ─── <leader>os (Visual) ──────────────────────────────────────────────────────
function M.send_snippet()
  local project_name, status, code_root = get_project_info()
  
  if not project_name then
    vim.notify("🚫 프로젝트 관리 대상 폴더가 아닙니다.", vim.log.levels.WARN, { title = "Obsidian Project" })
    return
  end

  local v_pos = vim.fn.getpos("v")
  local c_pos = vim.fn.getpos(".")
  local s = v_pos[2]
  local e = c_pos[2]
  if s > e then s, e = e, s end

  if not s or not e or s == 0 or e == 0 then
    vim.notify("선택 영역을 가져오는 데 실패했습니다.", vim.log.levels.WARN, { title = "Obsidian Snippet" })
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  local code  = table.concat(lines, "\n")
  local abs_path = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local ft       = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local ts       = os.date("%Y-%m-%d %H:%M")

  local snippet = string.format(
    "\n### 📝 Snippet: [%s (L%d-L%d)](file://%s) — %s\n```%s\n%s\n```\n",
    filename, s, e, abs_path, ts, ft, code
  )

  local target_dir = get_target_obsidian_dir(status) .. "/" .. project_name
  local note_path = target_dir .. "/" .. project_name .. ".md"
  
  ensure_note(note_path, project_name, code_root)

  local f = io.open(note_path, "a")
  if f then
    f:write(snippet)
    f:close()
    vim.notify(
      string.format("📎 %s  L%d – L%d  →  %s", filename, s, e, project_name),
      vim.log.levels.INFO,
      { title = "Obsidian 스니펫 전송 완료!" }
    )
  else
    vim.notify("❌ 쓰기 실패: " .. note_path, vim.log.levels.ERROR, { title = "Obsidian Snippet" })
  end
end

-- ─── 자동 동기화 트리거용 ──────────────────────────────────────────────────
function M.get_current_project_info()
  return get_project_info()
end

function M.get_obsidian_dirs()
  return OBSIDIAN_ACT, OBSIDIAN_ARC
end

function M.get_code_dirs()
  return CODE_ACT, CODE_ARC
end

return M
