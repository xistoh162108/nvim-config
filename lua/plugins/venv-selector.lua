return {
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectLog" },
    keys = {
      { ",v", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { ",V", "<cmd>VenvSelectCached<cr>", desc = "Select cached venv" },
    },
    opts = {
      -- 기본값으로도 충분. 필요하면 나중에 search 추가하면 됨.
      options = {
        -- 문제 생기면 켜서 로그 확인
        -- log_level = "DEBUG",
      },
    },
  },
}
