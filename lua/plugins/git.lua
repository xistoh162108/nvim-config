-- ~/.config/nvim/lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      current_line_blame = false,
      current_line_blame_opts = { delay = 500 },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>go", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview history" },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },

  {
    "SuperBo/fugit2.nvim",
    cmd = { "Fugit2", "Fugit2Graph" },
    keys = {
      { "<leader>gS", "<cmd>Fugit2<CR>", desc = "Fugit2 status" },
      { "<leader>gG", "<cmd>Fugit2Graph<CR>", desc = "Fugit2 graph" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
}
