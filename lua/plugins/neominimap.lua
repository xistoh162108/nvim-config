---@module "neominimap.config.meta"
return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  enabled = true,
  lazy = false, -- 추천: lazy 로딩 안 함
  keys = {
    -- Global
    { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
    { "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
    { "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
    { "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

    -- Window
    { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
    { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },

    -- Focus
    { "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
    { "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
  },
  init = function()
    -- float 레이아웃 쓸 때 도움되는 옵션(README 권장)
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36

    vim.g.neominimap = {
      auto_enable = true, -- 파일 열면 자동으로 미니맵 켜짐
      -- 원하면 여기서 옵션 더 추가 가능
      -- layout = "split", -- split로 고정하고 싶으면(예시)
    }
  end,
}
