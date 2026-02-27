-- TERMINAL (snacks.nvim)
vim.keymap.set({ "n", "t" }, "<leader>tf", function()
  -- Toggle a floating terminal (using current shell)
  local shell = vim.o.shell or vim.fn.getenv("SHELL")
  require("snacks.terminal").toggle(shell, {
    win = { style = "float", relative = "editor", width = 0.8, height = 0.8 },
  })
end, { desc = "Toggle Floating Terminal" })

vim.keymap.set({ "n", "t" }, "<leader>ts", function()
  -- Toggle a terminal in a split (bottom)
  require("snacks.terminal").toggle()
end, { desc = "Toggle Terminal (split)" })

-- GIT (LazyGit + Gitsigns)
vim.keymap.set("n", "<leader>gg", function()
  require("snacks").lazygit()
end, { desc = "Open LazyGit (Float)" })
-- Gitsigns navigation
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  require("gitsigns").next_hunk()
  return "<Ignore>"
end, { desc = "Next Git Hunk", expr = true })

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  require("gitsigns").prev_hunk()
  return "<Ignore>"
end, { desc = "Prev Git Hunk", expr = true })
-- Gitsigns actions
vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>hu", require("gitsigns").undo_stage_hunk, { desc = "Undo Stage Hunk" })
vim.keymap.set("v", "<leader>hs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage Hunk (Selection)" })
vim.keymap.set("v", "<leader>hr", function()
  require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset Hunk (Selection)" })
vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>hb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame Line" })

-- LSP (Language Server Protocol)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Document" })
vim.keymap.set("x", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Selection" })
-- (Optional extra LSP navigation)
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Find References" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })

-- DAP (Debugging)
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug Continue/Start" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug Step Into" })
vim.keymap.set("n", "<leader>dO", function()
  require("dap").step_over()
end, { desc = "Debug Step Over" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

-- FILE EXPLORER (Neo-tree or oil.nvim)
vim.keymap.set("n", "<leader>e", function()
  -- Toggle file explorer (project root). Use oil if available, else Neo-tree.
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open() -- open oil at cwd (project)
  else
    vim.cmd("Neotree toggle")
  end -- toggle Neo-tree
end, { desc = "Explorer (Project)" })

vim.keymap.set("n", "<leader>E", function()
  -- Open explorer at current file's directory
  local cur_dir = vim.fn.expand("%:p:h")
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open(cur_dir) -- oil at current file dir
  else
    vim.cmd("Neotree toggle dir=" .. cur_dir)
  end -- Neo-tree at current file dir
end, { desc = "Explorer (Current File Dir)" })

-- TELESCOPE finders
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files (Project)" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live Grep (Project)" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Find Help Tags" })

-- ===========================
-- MARKET WATCHER
-- ===========================
vim.keymap.set("n", "<leader>M", function()
  local ok, market = pcall(require, "core.market")
  if ok then market.toggle() end
end, { desc = "Toggle Market Watcher" })



-- ===========================
-- BUFFER DELETE & LAYOUT PROTECTION
-- ===========================
vim.keymap.set("n", "<leader>bd", function()
  local cur_win = vim.api.nvim_get_current_win()
  
  -- 열려있는 유효(Listed) 파일 버퍼 개수 세기
  local listed_bufs = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      -- 터미널 버퍼 등은 개수에서 제외
      if not string.match(name, "^term://") and vim.bo[buf].buftype ~= "terminal" then
        listed_bufs = listed_bufs + 1
      end
    end
  end

  -- 원래 Snacks.bufdelete 실행
  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks and snacks.bufdelete then
    snacks.bufdelete()
  else
    vim.cmd("bp|sp|bn|bd!")
  end

  -- 마지막 버퍼였다면 삭제 직후 현재 창에서 대시보드 렌더링
  if listed_bufs <= 1 then
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(cur_win) then
        vim.api.nvim_set_current_win(cur_win)
        if ok_snacks and snacks.dashboard then
          -- Snacks 대시보드를 버퍼 영역(현재 창)에 띄우기 (다른 split 닫힘 방지)
          snacks.dashboard.open({ win = cur_win })
        end
      end
    end)
  end
end, { desc = "Delete Buffer & Protect Layout" })

-- CUSTOM CHEATSHEET
vim.keymap.set("n", "<leader>?", function()
  -- If a cheatsheet window is already open, close it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].is_cheatsheet then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.b[buf].is_cheatsheet = true
  local lines = {
    "# ⚡ NEOVIM CORE CHEATSHEET ⚡",
    "---",
    "| Move & Edit              | Window & File                |",
    "|--------------------------|------------------------------|",
    "| `s` / `S` Flash 점프       | `⇧H` / `⇧L` 이전/다음 탭         |",
    "| `w` / `b` / `e` 단어 점프  | `Spc b d` 현재 버퍼 닫기       |",
    "| `ciw` / `diw` 단어변경/삭제| `^w v/s` 수평/수직 분할        |",
    "| `dd` / `yy` 줄 삭제/복사   | `^w =/q` 크기맞춤/닫기         |",
    "| `u` / `^r` 취소/재실행     | `:w` / `:q` 저장/종료          |",
    "| `ci\"` 안쪽 내용 변경       |                              |",
    "",
    "| Telescope & Search       | LSP & Code                   |",
    "|--------------------------|------------------------------|",
    "| `Spc f f` 파일 찾기        | `g d` 정의 위치로              |",
    "| `Spc f g` 텍스트 검색      | `K` / `g r` 호버설명/참조       |",
    "| `Spc f b` 열린 버퍼 찾기   | `Spc c a` 코드 자동복구(Fix)   |",
    "| `Spc s t` Todo 검색        | `Spc c r` 변수명 일괄변경      |",
    "| `Spc s k` 단축키 검색!     | `Spc c f` 파일 자동 정렬       |",
    "| `/` / `%` 버퍼검색/괄호점프| `Spc x x` 에러 목록 보기(Trouble)|",
    "|                          | `]c` / `[c` 다음/이전 Hunk       |",
    "",
    "| Tool & AI                | DB & Harpoon                 |",
    "|--------------------------|------------------------------|",
    "| `Spc g g` LazyGit 열기     | `Spc D` DBUI 토글              |",
    "| `Spc a a` AI 채팅(Avante)  | `Spc h a` Harpoon 추가         |",
    "| `^l` (삽입) AI 제안 수락   | `Spc h h` Harpoon 메뉴         |",
    "| `Spc t f` 터미널 열기      | `Spc h 1~4` 1~4번 마크 점프    |",
    "| `Spc r c` 원격(SSH) 접속   | `Spc t t` 다크/라이트 테마     |",
    "",
    "---",
    "> **💡 닫기:** `q` 또는 `<ESC>` 또는 `<Space>?`",
    "> **💡 논-리더단축키 찾기:** `<Space> s k` 입력 !"
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  local width = 70
  local height = #lines + 2
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Cheat Sheet ",
    title_pos = "center",
  })

  -- 반투명 설정 (Optional)
  pcall(vim.api.nvim_win_set_option, win, "winblend", 10)

  -- Close mappings
  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
  vim.keymap.set("n", "<ESC>", "<cmd>close<CR>", opts)
  vim.keymap.set("n", "<leader>?", "<cmd>close<CR>", opts)
end, { desc = "Toggle Floating Cheatsheet" })

-- ALL KEYMAPS SEARCH
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "Search Keymaps" })
