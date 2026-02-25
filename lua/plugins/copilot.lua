return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      panel = {
        enabled = false, -- 처음엔 panel 끄고 ghost text만 사용
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- 입력하면 자동 제안
        hide_during_completion = true, -- blink/cmp 메뉴 뜰 때 숨김
        debounce = 75,
        keymap = {
          accept = false, -- 직접 키맵으로 처리 (충돌 방지)
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },

      -- 민감 파일/특정 타입 제외 가능
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = true,
        yaml = true,
        ["*"] = true,
      },

      -- 필요하면 나중에 맞춤 node 경로 지정
      -- copilot_node_command = vim.fn.expand("$HOME/.nvm/versions/node/v22.0.0/bin/node"),

      -- offset encoding 경고 줄이기 (일부 LSP 환경)
      server_opts_overrides = {
        settings = {
          advanced = {
            inlineSuggestCount = 3,
            listCount = 10,
          },
        },
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- ===========
      -- 키맵 (iTerm2 Alt키 안 먹는 경우 대비)
      -- ===========
      local sug_ok, suggestion = pcall(require, "copilot.suggestion")
      if not sug_ok then
        return
      end

      -- iTerm2에서 안정적인 대체 키맵 (Ctrl 계열)
      vim.keymap.set("i", "<C-l>", function()
        if suggestion.is_visible() then
          suggestion.accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
        end
      end, { desc = "Copilot Accept Suggestion", silent = true })

      vim.keymap.set("i", "<C-j>", function()
        if suggestion.is_visible() then
          suggestion.accept_word()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, false, true), "n", false)
        end
      end, { desc = "Copilot Accept Word", silent = true })

      vim.keymap.set("i", "<C-;>", function()
        if suggestion.is_visible() then
          suggestion.next()
        end
      end, { desc = "Copilot Next Suggestion", silent = true })

      vim.keymap.set("i", "<C-,>", function()
        if suggestion.is_visible() then
          suggestion.prev()
        end
      end, { desc = "Copilot Prev Suggestion", silent = true })

      vim.keymap.set("i", "<C-]>", function()
        if suggestion.is_visible() then
          suggestion.dismiss()
        end
      end, { desc = "Copilot Dismiss Suggestion", silent = true })

      -- 색상 (원하면)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          pcall(vim.api.nvim_set_hl, 0, "CopilotSuggestion", { link = "Comment" })
          pcall(vim.api.nvim_set_hl, 0, "CopilotAnnotation", { link = "Comment" })
        end,
      })
    end,
  },
}
