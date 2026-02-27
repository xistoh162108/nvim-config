return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = false,
      terminal_colors = true,
      dim_inactive = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      on_highlights = function(hl, c)
        -- inactive border는 조금 덜 밝은 파란색, active는 네온 시안으로 확실하게 구분
        local inactive_border = "#7aa2f7" 
        local active_border = "#00e5ff" 
        local obsidian_purple = "#bb9af7" -- TokyoNight Purple
        
        -- 네오빔 기본 구분선 (비활성 창 포함)
        hl.WinSeparator = { fg = inactive_border, bold = true }
        hl.ObsidianWinSeparator = { fg = obsidian_purple, bold = true }
        
        -- 플로팅 창 구분선
        hl.FloatBorder = { fg = inactive_border, bold = true }
        -- 기타 플러그인 구분선들
        hl.TelescopeBorder = { fg = active_border, bold = true }
        hl.NeoTreeWinSeparator = { fg = inactive_border, bold = true }
        hl.SnacksPickerBorder = { fg = active_border, bold = true }
        
        -- colorful-winsep 플러그인이 쓰는 활성 창 색상
        hl.ColorfulWinsep = { fg = active_border, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },



  -- Window Separator Enhancer
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
    opts = {
      interval = 30,
      no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree", "neo-tree", "oil", "snacks_dashboard", "alpha" },
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
    },
  }
}
