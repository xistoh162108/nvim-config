-- lua/plugins/fun.lua
-- 스트레스 해소 + 코드 스크린샷 유틸

return {
  -- cellular-automaton.nvim: 코드가 물리 엔진처럼 와르르 쏟아지거나 Game of Life 로 변함
  {
    "eandrju/cellular-automaton.nvim",
    enabled = false,
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain ☔" },
      { "<leader>fmg", "<cmd>CellularAutomaton game_of_life<CR>", desc = "Game of Life 🧬" },
    },
  },

  -- codesnap.nvim: macOS 스타일 그림자 + 배경이 들어간 코드 스크린샷
  --   Visual 선택 후 <leader>cs → 클립보드 복사
  --   Visual 선택 후 <leader>cS → ~/Desktop 에 PNG 저장
  {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = { "CodeSnap", "CodeSnapSave" },
    opts = {
      mac_window_bar     = true,
      watermark          = "",
      has_breadcrumbs    = true,
      show_workspace     = true,
      save_path          = vim.fn.expand("~/Desktop"),
      bg_theme           = "default",
    },
    keys = {
      { "<leader>cs", ":'<,'>CodeSnap<CR>",     mode = "x", desc = "CodeSnap → 클립보드" },
      { "<leader>cS", ":'<,'>CodeSnapSave<CR>", mode = "x", desc = "CodeSnap → 파일 저장" },
    },
  },
}
