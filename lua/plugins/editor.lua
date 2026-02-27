-- ~/.config/nvim/lua/plugins/editor.lua
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = true },
        char = { enabled = false },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "<leader>-", "<cmd>Oil<CR>", desc = "Open parent directory (Oil)" },
    },
    opts = {
      default_file_explorer = false,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
    },
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" },
        silent_chdir = false,
      })
      pcall(function()
        require("telescope").load_extension("projects")
      end)
    end,
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        custom_filter = function(buf_number, buf_numbers)
          -- 터미널 버퍼이거나 이름이 term:// 로 시작하면 bufferline에서 숨김
          local bt = vim.bo[buf_number].buftype
          if bt == "terminal" then return false end
          local file_path = vim.api.nvim_buf_get_name(buf_number)
          if string.match(file_path, "^term://") then return false end
          
          -- 그 외(일반 파일)만 표시
          return true
        end,
      },
    },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
  },

  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      current_only = false,
      handlers = {
        cursor = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true },
        marks = { enable = true },
      },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        names = false,
      },
    },
  },
}
