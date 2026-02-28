-- lua/plugins/aerial.lua
-- Architect's Code Map (Treesitter-powered Outline)

return {
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    config = function(_, opts)
      require("aerial").setup(opts)

      -- Auto-open aerial on code buffers (more reliable than open_automatic)
      local skip_ft = {
        "", "aerial", "neo-tree", "oil", "toggleterm", "alpha",
        "dashboard", "snacks_dashboard", "lazy", "mason", "notify",
        "TelescopePrompt", "help", "qf", "Trouble", "trouble",
      }
      -- [Disabled] 사용자의 요청으로 시작 시 우측 Outline 자동 띄우기 비활성화
      -- vim.api.nvim_create_autocmd("BufWinEnter", {
      --   group = vim.api.nvim_create_augroup("AerialAutoOpen", { clear = true }),
      --   callback = function()
      --     local ft = vim.bo.filetype
      --     for _, f in ipairs(skip_ft) do
      --       if ft == f then return end
      --     end
      --     -- Only open for listed buffers (not scratch/utility)
      --     if not vim.bo.buflisted then return end
      --     pcall(require("aerial").open, { focus = false })
      --   end,
      -- })
    end,
    opts = {
      attach_mode = "window",   -- aerial opens right of the current buffer window
      close_automatic_events = {},
      layout = {
        max_width = { 35, 0.2 },
        min_width = 35,
        default_direction = "right",
      },
      filter_kind = {
        "Class", "Constructor", "Enum", "Function",
        "Interface", "Module", "Method", "Struct",
      },
      highlight_on_hover = true,
      autojump = true,
      show_guides = true,
      guides = {
        mid_item   = "├─",
        last_item  = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
    keys = {
      { "<leader>O", "<cmd>AerialToggle!<cr>", desc = "Aerial (Code Map) Toggle" },
    },
  },
}
