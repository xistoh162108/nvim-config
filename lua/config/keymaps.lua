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
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
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
