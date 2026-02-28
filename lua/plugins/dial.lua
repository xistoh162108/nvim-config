-- lua/plugins/dial.lua
-- dial.nvim: Supercharged <C-a>/<C-x> for booleans, dates, IP, semver

return {
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d/%Y"],
          augend.constant.alias.bool,           -- true/false
          augend.semver.alias.semver,            -- 1.2.3 → 1.2.4
          -- IP address increment (last octet)
          augend.integer.new({
            radix = 10,
            prefix = "",
            natural = true,
            case = "lower",
          }),
          -- Custom: yes/no, on/off, enable/disable
          augend.constant.new({ elements = { "yes", "no" } }),
          augend.constant.new({ elements = { "on", "off" } }),
          augend.constant.new({ elements = { "enable", "disable" } }),
          augend.constant.new({ elements = { "enabled", "disabled" } }),
          augend.constant.new({ elements = { "left", "right" } }),
          augend.constant.new({ elements = { "top", "bottom" } }),
        },
      })
    end,
    keys = {
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Dial: Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Dial: Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Dial: Increment (g)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Dial: Decrement (g)" },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = "v", desc = "Dial: Increment (v)" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = "v", desc = "Dial: Decrement (v)" },
    },
  },
}
