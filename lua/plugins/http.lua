-- lua/plugins/http.lua
-- REST Client for API Testing (kulala.nvim)

return {
  {
    "mistweaverco/kulala.nvim",
    event = "VeryLazy",
    opts = {
      -- 응답 창 설정
      display_mode = "split",
      split_direction = "vertical",
      default_view = "body",
      -- UI 테마 (Cyberpunk 스타일에 어울리게)
      icons = {
        inbound = "󰖟 ",
        outbound = "󰖝 ",
      },
    },
    keys = {
      { "<leader>Kr", function() require("kulala").run() end, desc = "HTTP: Run Request" },
      { "<leader>Kp", function() require("kulala").jump_prev() end, desc = "HTTP: Prev Request" },
      { "<leader>Kn", function() require("kulala").jump_next() end, desc = "HTTP: Next Request" },
      { "<leader>Ki", function() require("kulala").inspect() end, desc = "HTTP: Inspect Request" },
      { "<leader>KS", function() require("kulala").show_stats() end, desc = "HTTP: Show Stats" },
      { "<leader>Kq", function() require("kulala").close() end, desc = "HTTP: Close kulala" },
      { "<leader>Kc", function() require("kulala").copy_as_curl() end, desc = "HTTP: Copy as CURL" },
    },
  },
}
