return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- 투명 배경 활성화 (진짜 사이버펑크 느낌)
      transparent = true,

      -- 기울임꼴 주석
      italic_comments = true,

      -- 터미널 색상도 같이 적용
      terminal_colors = true,

      -- 테두리 없는 picker (Telescope 등)
      borderless_pickers = true,

      -- 채도 조절 (0.0~1.0, 기본 1.0)
      saturation = 1,
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)

      -- 다크/라이트 토글 키맵 추가
      vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto", -- cyberdream 자동 매칭
      },
    },
  },
}
