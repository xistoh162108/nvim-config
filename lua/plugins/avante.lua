return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- 최신 유지 (README 권장)
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",

      -- input/picker/UI (선택)
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      "hrsh7th/nvim-cmp",

      -- 선택: Copilot provider 연동용 (안 써도 설치 가능)
      "zbirenbaum/copilot.lua",

      -- 선택: markdown 렌더링
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        opts = {
          file_types = { "markdown", "Avante" },
        },
      },

      -- 선택: 이미지 붙여넣기
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },

    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- 프로젝트 루트의 avante.md를 자동 컨텍스트로 사용
      instructions_file = "avante.md",

      -- 기본 provider (처음엔 claude 추천)
      provider = "claude",

      -- 필요 시 agentic/legacy 선택
      mode = "agentic",

      -- 툴이 너무 과하게 실행되면 일부 비활성화 가능
      -- disabled_tools = { "python", "bash" },

      -- Fast Apply (Morph 쓰려면 키 필요)
      behaviour = {
        enable_fastapply = false, -- 처음엔 false로 시작 추천
      },

      -- UI / 창 설정
      windows = {
        position = "right", -- 너 레이아웃과 잘 맞음
        wrap = true,
        width = 23, -- 너무 넓으면 줄이기
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },

        ask = {
          start_insert = true,
          floating = false,
        },

        input = {
          height = 4,
        },

        selected_files = {
          height = 4,
        },
      },

      -- provider 상세 설정 (최신 README 스타일)
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000,
          auth_type = "max",
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
          -- Claude 구독 로그인 방식 쓰려면:
          -- auth_type = "max",
        },

        -- 필요하면 나중에 켜기
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o-mini",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },

        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-2.0-flash",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },

      mappings = {
        --- @class AvanteConflictMappings
        conflict = {
          accept = "y",
          reject = "n",
          jump_next = "]x",
          jump_prev = "[x",
        },
        submit = {
          normal = "<CR>",
          insert = "<CR>", -- 엔터로 바로 전송되게 변경
        },
      },

      -- file selector provider 충돌 줄이기 (snacks/tele/telescope 중 취향)
      selector = {
        provider = "snacks", -- 너 snacks 쓰는 편이라 이걸로
        exclude_auto_select = { "neo-tree", "NvimTree", "snacks_dashboard" },
      },

      input = {
        provider = "snacks",
      },
    },

    keys = {
      -- 기본
      { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
      { "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Avante Focus" },
      { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante Refresh" },

      -- 편집/리뷰
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = { "v" }, desc = "Avante Edit (selection)" },
      { "<leader>aR", "<cmd>AvanteShowRepoMap<cr>", desc = "Avante RepoMap" },
      { "<leader>am", "<cmd>AvanteModels<cr>", desc = "Avante Models" },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<cr>", desc = "Avante Switch Provider" },
      { "<leader>ad", function()
        -- Agentic Debug: 현재 버퍼의 Diagnostics(에러)를 수집하여 Avante에게 전달
        local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        if #diagnostics == 0 then
          diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        end
        
        if #diagnostics == 0 then
          vim.notify("No diagnostics found to debug!", vim.log.levels.INFO)
          return
        end

        local error_messages = {}
        for _, diag in ipairs(diagnostics) do
          table.insert(error_messages, string.format("Line %d: %s", diag.lnum + 1, diag.message))
        end

        local prompt = "I have the following diagnostics in this file:\n\n" .. 
                       table.concat(error_messages, "\n") .. 
                       "\n\nPlease analyze these errors and suggest a fix."
        
        require("avante.api").ask({ question = prompt })
      end, desc = "Avante Debug (Diagnostics Fix)" },
      { "<leader>as", "<cmd>AvanteStop<cr>", desc = "Avante Stop" },
      { "<leader>an", "<cmd>AvanteChatNew<cr>", desc = "Avante New Chat" },
      { "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "Avante History" },
    },

    config = function(_, opts)
      -- 권장 옵션 (README 팁)
      vim.opt.laststatus = 3

      require("avante").setup(opts)
    end,
  },
}
