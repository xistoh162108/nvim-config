-- lua/plugins/smear_cursor.lua
-- Smooth cursor smear animation (sphamba/smear-cursor.nvim)

return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Cursor color (follows CursorLine by default)
      cursor_color = "#d6c9f1",
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      -- Disable in insert mode to avoid visual clutter while typing
      hide_target_hack = true,
    },
  },
}
