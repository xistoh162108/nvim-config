return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>O", "<cmd>Outline<CR>", desc = "Outline Toggle" },
    },
    opts = {
      outline_window = {
        position = "right", -- 다시 오른쪽으로 원복
        width = 35,         -- 너비 확보
        auto_close = false,
      },
    },
  },
}