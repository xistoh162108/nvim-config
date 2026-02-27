return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    modes = {
      diagnostics = {
        auto_open = false,
        auto_close = true,
      },
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "진단 (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "버퍼 진단" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "심볼 (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    { "<leader>xr", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP (refs/defs)" },
  },
}
