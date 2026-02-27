-- lua/plugins/hex.lua
-- Pure Lua Hex Editor (hexview.nvim)
--   Alternative to xxd-based editors. Fast and dependency-free.

return {
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexView", "HexViewToggle" },
    opts = {
      -- Default options are usually sufficient
      -- Provides side-by-side Hex and ASCII view
    },
    keys = {
      { "<leader>hx", "<cmd>HexViewToggle<cr>", desc = "Binary: Toggle HexView" },
    },
  },
}
