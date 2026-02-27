-- lua/plugins/undotree.lua
-- Visual Undo History (undotree)

return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "History: Toggle Undotree" },
    },
    init = function()
      -- Persistent Undo Enable (Core Neovim Setting)
      if vim.fn.has("persistent_undo") == 1 then
        local target_path = vim.fn.expand("~/.config/nvim/.undo")
        if vim.fn.isdirectory(target_path) == 0 then
          vim.fn.mkdir(target_path, "p")
        end
        vim.opt.undodir = target_path
        vim.opt.undofile = true
      end
    end,
  },
}
