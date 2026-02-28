-- ~/.config/nvim/lua/plugins/grug_far.lua
-- Phase 20 (Step 1): Global Search & Replace (VS Code Cmd+Shift+F Equivalent)

return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (Grug Far)",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        mode = { "n", "v" },
        desc = "Search Word under cursor (Grug Far)",
      },
    },
    opts = {
      headerMaxWidth = 80,
    },
  },
}
