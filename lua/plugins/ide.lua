-- ~/.config/nvim/lua/plugins/ide.lua
return {
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
