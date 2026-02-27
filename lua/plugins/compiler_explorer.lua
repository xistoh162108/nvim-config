-- lua/plugins/compiler_explorer.lua
-- Real-time C-to-ASM learning tool (compiler-explorer.nvim)

return {
  {
    "krady21/compiler-explorer.nvim",
    cmd = { "CompilerExplorer", "CompilerExplorerOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- TokyoNight compatible colors will be handled by the plugin's default link to highlights
      autocmd = {
        enable = true,
      },
    },
    keys = {
      { "<leader>ce", "<cmd>CompilerExplorer<cr>", desc = "Docs: Compiler Explorer" },
    },
  },
}
