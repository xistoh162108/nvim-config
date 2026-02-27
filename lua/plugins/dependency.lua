-- lua/plugins/dependency.lua
-- Dependency Version Intelligence (Node.js & Rust)

return {
  -- 1) package-info.nvim: npm dependency versions in virtual text
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      colors = {
        up_to_date = "#3d59a1", -- TokyoNight Blue (matching theme)
        outdated = "#ebdbb2",
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "| 🚀 up to date",
          outdated = "| ⚠️ outdated",
        },
      },
      autostart = true,
    },
    keys = {
      { "<leader>cv", function() require("package-info").show() end, desc = "Package: Show versions" },
      { "<leader>cc", function() require("package-info").hide() end, desc = "Package: Hide versions" },
      { "<leader>cu", function() require("package-info").update() end, desc = "Package: Update dependency" },
      { "<leader>cd", function() require("package-info").delete() end, desc = "Package: Delete dependency" },
      { "<leader>ci", function() require("package-info").install() end, desc = "Package: Install dependency" },
      { "<leader>cp", function() require("package-info").change_version() end, desc = "Package: Change version" },
    },
  },

  -- 2) crates.nvim: Rust/Cargo version intelligence
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
      popup = {
        autofocus = true,
        border = "rounded",
      },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
    end,
  },
}
