-- lua/plugins/repl.lua
-- REPL-Driven Development (IPython + iron.nvim) + Terminal Management (ToggleTerm)

return {
  -- 1) ToggleTerm: 강력한 터미널 관리
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      -- open_mapping removed: ToggleTerm is REPL backend only. UI terminal via Snacks.
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "vertical", -- 기본적으로 수직 분할 사용 (ML 작업에 유리)
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 3,
      },
    },
    keys = {
      -- UI keymaps removed: <leader>tf/tv/th now belong to Snacks.terminal
      -- ToggleTerm is invoked only by iron.nvim internals (repl_open_cmd)
    },
  },

  -- 2) iron.nvim: 전문적인 REPL 엔진
  {
    "hkupty/iron.nvim",
    event = "BufRead", -- 필요할 때 로드
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")

      iron.setup({
        config = {
          -- 리플 창을 어떻게 띄울지 (ToggleTerm과 조화롭게 사용 가능)
          repl_open_cmd = view.split.vertical.botright("40%"),
          -- 대상 언어별 REPL 정의
          repl_definition = {
            python = {
              command = { "ipython", "--no-autoindent" },
              format = function(lines)
                local joined = table.concat(lines, "\n")
                return { joined .. "\n" }
              end,
            },
            javascript = {
              command = { "node" },
            },
            typescript = {
              command = { "ts-node" },
            },
          },
          -- 리플로 보낼 때 자동 스크롤
          should_set_cursor = false,
        },
        -- 키맵 설정 (LSP 단축키와 겹치지 않게 <leader>r 사용)
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rr",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_paragraph = "<leader>rp",
          send_until_cursor = "<leader>rt",
          send_mark = "<leader>rm",
          mark_motion = "<leader>rmc",
          mark_visual = "<leader>rmv",
          remove_mark = "<leader>rmd",
          cr = "<leader>r<cr>",
          interrupt = "<leader>ri",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },
        -- 하이라이트
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
    end,
    keys = {
      { "<leader>rs", "<cmd>IronRepl<cr>", desc = "REPL: Start (iron)" },
      { "<leader>rR", "<cmd>IronRestart<cr>", desc = "REPL: Restart" },
      { "<leader>rf", "<cmd>IronFocus<cr>", desc = "REPL: Focus" },
      { "<leader>rh", "<cmd>IronHide<cr>", desc = "REPL: Hide" },
    },
  },
}
