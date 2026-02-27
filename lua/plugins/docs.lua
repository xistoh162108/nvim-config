-- lua/plugins/docs.lua
-- Integrated Offline Documentation (devdocs.nvim)
--   Alternative to archived nvim-devdocs. Faster and maintained.

return {
  {
    "maskudo/devdocs.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      dir_path = vim.fn.stdpath("data") .. "/devdocs", -- 문서 저장 경로
      -- 수동 설치 필요: :DevDocs install <engine>
      -- 예: :DevDocs install python react tailwind_css
    },
    keys = {
      { "<leader>ds", "<cmd>DevDocs search<cr>", desc = "Docs: Search (DevDocs)" },
      { "<leader>di", "<cmd>DevDocs install<cr>", desc = "Docs: Install Engine" },
      { "<leader>dg", "<cmd>DevDocs get<cr>", desc = "Docs: Get Current Symbol" },
      { "<leader>dl", "<cmd>DevDocs list<cr>", desc = "Docs: List Installed" },
    },
  },
}
