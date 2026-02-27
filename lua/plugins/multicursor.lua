return {
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",         -- VSCode Ctrl+D
        ["Find Subword Under"] = "<C-d>",
        ["Add Cursor Down"] = "<C-Down>",
        ["Add Cursor Up"] = "<C-Up>",
        ["Select All"] = "<C-A-n>",
        ["Exit"] = "<Esc>",
      }
      vim.g.VM_highlight_matches = "hi! link VM_Mono Search"
    end,
  },
}
