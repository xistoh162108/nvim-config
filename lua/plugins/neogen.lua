return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = "Neogen",
  keys = {
    {
      "<leader>ng",
      function()
        require("neogen").generate()
      end,
      desc = "Neogen: Generate doc",
    },
    {
      "<leader>nG",
      function()
        require("neogen").generate({ type = "class" })
      end,
      desc = "Neogen: Class doc",
    },
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      input_after_comment = true, -- 생성 후 커서를 주석 안으로 이동
      -- snippet_engine = "nvim", -- 스니펫 엔진 안 쓰면 굳이 설정 안 해도 됨
    })
  end,
}
