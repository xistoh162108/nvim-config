-- lua/plugins/overrides.lua
-- Architect's Hygiene: Explicitly disabling redundant LazyVim defaults or second-tier plugins.

return {
  -- 1. Disable LazyVim's default session manager (favors auto-session in session.lua)
  { "folke/persistence.nvim", enabled = false },

  -- 2. Disable Supermaven (favors copilot.lua for inline completion)
  { "supermaven-inc/supermaven-nvim", enabled = false },

  -- 3. Disable satellite.nvim (scrollbar): neominimap already provides spatial orientation.
  --    Redundant right-side visual density removed. Phase 17.4.
  { "lewis6991/satellite.nvim", enabled = false },
}
