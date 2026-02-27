return {
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = {
      bar = {
        enable = function(buf, win)
          local bt = vim.bo[buf].buftype
          local ft = vim.bo[buf].filetype
          local blocked = {
            ["neo-tree"] = true,
            ["Outline"] = true,
            ["outline"] = true,
            ["dashboard"] = true,
            ["snacks_dashboard"] = true,
            ["lazy"] = true,
            ["mason"] = true,
            ["help"] = true,
            ["TelescopePrompt"] = true,
            ["Trouble"] = true,
            ["trouble"] = true,
            ["dap-repl"] = true,
          }
          return not vim.api.nvim_win_get_config(win).zindex
            and bt == ""
            and not blocked[ft]
            and vim.api.nvim_buf_get_name(buf) ~= ""
        end,
        pick = { pivots = "abcdefghijklmnopqrstuvwxyz" },
      },
    },
    keys = {
      {
        "<leader>.",
        function() require("dropbar.api").pick() end,
        desc = "Dropbar: pick (breadcrumb)",
      },
    },
  },
}
