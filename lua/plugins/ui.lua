-- ~/.config/nvim/lua/plugins/ui.lua
return {
  -- notify/noice
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 2000,
      stages = "fade_in_slide_out",
      render = "default",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      notify = { enabled = false }, -- nvim-notify와의 충돌 방지용 (vim.notify overwrite 에러 해결)
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false, -- blink.cmp 자동완성 팝업과 충돌/깜빡임 방지를 위해 기본 하단 커맨드라인 사용
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    keys = {
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice history",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice last message",
      },
      { "<leader>nd", "<cmd>NoiceDismiss<CR>", desc = "Noice dismiss" },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = true },
      select = { enabled = true },
    },
  },

  -- snacks: dashboard (alpha 대신)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
     _                _
    | |    __ _ _   _(_)
    | |   / _` | | | | |
    | |__| (_| | |_| | |
    |_____\__,_|\__, |_|
               |___/
          ]],
        },
      },
      -- 나중에 필요하면 snacks의 picker/notifier 등도 여기서 켤 수 있음
    },
  },

  -- 인덴트 가이드
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "dashboard", -- snacks dashboard
          "neo-tree",
          "Trouble",
          "lazy",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
