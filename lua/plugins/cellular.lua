-- lua/plugins/cellular.lua
-- Mental Health Booster (cellular-automaton.nvim)
--   The ultimate developer easter egg for stressful debugging.

return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>fX", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Fun: Make it Rain" },
      { "<leader>fG", "<cmd>CellularAutomaton game_of_life<cr>", desc = "Fun: Game of Life" },
    },
  },
}
