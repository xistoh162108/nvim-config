return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      preset = "modern",
    },
    keys = {
      { "<leader>dt", "<cmd>TinyInlineDiag toggle<cr>", desc = "Toggle inline diagnostics" },
      { "<leader>de", "<cmd>TinyInlineDiag enable<cr>", desc = "Enable inline diagnostics" },
      { "<leader>dd", "<cmd>TinyInlineDiag disable<cr>", desc = "Disable inline diagnostics" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- 중요: 기본 inline 텍스트 끄고 tiny가 대신 표시
      },
    },
  },
}
