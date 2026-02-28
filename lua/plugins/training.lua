-- lua/plugins/training.lua
-- Phase 17.5: Spartan Training Mode

return {
  -- 1) hardtime.nvim: Blocks repeated inefficient motions (e.g., jjjj) and suggests better macros/motions
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false, -- We already set vim.opt.mouse="" globally
      hint = true,
      max_count = 3, -- reduce allowed repeats to make hjkl training more effective
      allow_different_key = true,
      -- Apply Hardtime to ALL windows, plugins, and buffers
      disabled_filetypes = {},
      disabled_buftypes = {},
      -- Strictly block arrow keys via Hardtime to show hints instead of global <Nop>
      -- Strictly block arrow keys and bad habits to show hints (Spartan Mode)
      restricted_keys = {
        ["<Up>"] = { "n", "x", "i", "c", "t" },
        ["<Down>"] = { "n", "x", "i", "c", "t" },
        ["<Left>"] = { "n", "x", "i", "c", "t" },
        ["<Right>"] = { "n", "x", "i", "c", "t" },
        -- Added Stricter Limits
        ["<CR>"] = { "n", "x" }, -- 막무가내 엔터 대신 모션을 쓰도록 유도
        ["<BS>"] = { "n", "x" }, -- 막무가내 백스페이스 대신 `X`나 `cw` 쓰도록 유도
        ["<PageUp>"] = { "n", "x" }, -- PageUp 대신 Ctrl+u 강제
        ["<PageDown>"] = { "n", "x" }, -- PageDown 대신 Ctrl+d 강제
      },
    },
    keys = {
      { "<leader>uh", "<cmd>Hardtime toggle<cr>", desc = "Toggle Hardtime Training" },
    },
  },

  -- 2) precognition.nvim: Visually displays upcoming valid motions as hints
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" }, -- Subtle styling
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
    },
    keys = {
      { "<leader>up", function() require("precognition").toggle() end, desc = "Toggle Precognition Hints" },
    },
  }
}
