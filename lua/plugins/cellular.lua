-- lua/plugins/cellular.lua
-- Mental Health Booster (cellular-automaton.nvim)

return {
  {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",  -- loads at startup; CellularAutomaton command always available
    keys = {
      { "<leader>fX", function() require("cellular-automaton").start_animation("make_it_rain") end,  desc = "Fun: Make it Rain 🌧️" },
      { "<leader>fG", function() require("cellular-automaton").start_animation("game_of_life") end,  desc = "Fun: Game of Life 🐛" },
    },
  },
}
