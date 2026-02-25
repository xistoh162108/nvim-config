-- ~/.config/nvim/lua/plugins/ide.lua
return {
  -- Diagnostics/References UI
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
      { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Trouble quickfix" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble loclist" },
      { "<leader>xr", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP (refs/defs)" },
    },
  },

  -- TODO/FIXME highlight + Telescope 연동
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Search TODO" },
    },
  },
}
