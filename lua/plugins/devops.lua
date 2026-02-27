-- lua/plugins/devops.lua
-- DevOps & Infrastructure Workflows (Docker, K8s, GitHub)

return {
  -- 1) Octo.nvim: GitHub PR/Issue Management in Neovim
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      default_remote = { "upstream", "origin" },
      ssh_aliases = {},
    },
  },

  -- 2) DevOps TUI Shortcuts (via ToggleTerm)
  --   Note: lazydocker and k9s must be installed on your system.
  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      -- 기존 설정을 유지하면서 새로운 터미널 인스턴스 생성 함수 추가
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazydocker Terminal Instance
      local lazydocker = Terminal:new({
        cmd = "lazydocker",
        direction = "float",
        hidden = true,
        float_opts = {
          border = "curved",
        },
        -- 창이 닫힐 때 인스턴스 유지
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- K9s Terminal Instance
      local k9s = Terminal:new({
        cmd = "k9s",
        direction = "float",
        hidden = true,
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- 전역 함수로 등록하여 키맵에서 호출 가능하게 함
      function _LAZYDOCKER_TOGGLE()
        lazydocker:toggle()
      end

      function _K9S_TOGGLE()
        k9s:toggle()
      end
    end,
    keys = {
      { "<leader>td", "<cmd>lua _LAZYDOCKER_TOGGLE()<CR>", desc = "DevOps: LazyDocker" },
      { "<leader>tk", "<cmd>lua _K9S_TOGGLE()<CR>", desc = "DevOps: K9s" },
    },
  },
}
