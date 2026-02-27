return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,       -- 상단에 최대 3줄까지 표시
      trim_scope = "outer", -- 바깥쪽 스코프를 잘라냄
      mode = "cursor",      -- 커서 위치 기준
    },
    keys = {
      { "<leader>tc", "<cmd>TSContextToggle<CR>", desc = "Toggle treesitter context" },
    },
  },
}
