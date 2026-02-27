-- lua/plugins/overseer.lua
-- Task Runner and Job Manager (overseer.nvim)
--   Perfect for C/ASM build loops (make, gcc) and server/client tasks.

return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
    opts = {
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 20,
        default_detail = 1,
      },
    },
    keys = {
      { "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Tasks: Run Task" },
      { "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Tasks: Toggle List" },
      { "<leader>ti", "<cmd>OverseerInfo<cr>", desc = "Tasks: Info" },
      { "<leader>tc", "<cmd>OverseerBuild<cr>", desc = "Tasks: Build" },
    },
  },
}
