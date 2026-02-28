-- lua/plugins/im_select.lua
-- Auto Input Method Switch (Korean ↔ English) on mode change
-- macism installed at: ~/.local/bin/macism
-- Korean IM ID: com.apple.inputmethod.Korean.2SetKorean
-- English IM ID: com.apple.keylayout.ABC

return {
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    config = function()
      require("im_select").setup({
        -- Default IM for Normal/Visual/Command mode → English
        default_im_select = "com.apple.keylayout.ABC",

        -- Absolute path to macism binary
        default_command = vim.fn.expand("~/.local/bin/macism"),

        -- Restore previous IM (e.g. Korean) when re-entering Insert mode
        set_previous_events = { "InsertEnter" },

        -- Switch to English when leaving Insert / command / entering Neovim
        set_default_events = { "VimEnter", "InsertLeave", "CmdlineLeave" },
      })
    end,
  },
}
