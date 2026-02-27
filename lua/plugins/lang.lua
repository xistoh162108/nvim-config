-- lua/plugins/lang.lua
-- LazyVim extra 들은 lua/config/lazy.lua 에서 user plugins 보다 먼저 import.
-- 여기는 LazyVim extra 에 없는 언어 / 개인 설정만 작성한다.

return {
  -- Bash / Shell
  --   LazyVim 에 lang.bash extra 없음 → Mason 으로 직접 설치
  --   bash-language-server, shfmt, shellcheck
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Mason UI를 float이 아닌 split으로 열어서 레이아웃 충돌 회피
      opts.ui = opts.ui or {}
      opts.ui.width = 0.8
      opts.ui.height = 0.8
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shfmt",
        "shellcheck",
        "basedpyright", -- Python LSP
        "ruff",         -- Python Linter/Formatter
      })
    end,
  },
  
  -- Python LSP 명시적 설정 (LazyVim 기반)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- Dart / Flutter
  --   dartls 는 Mason 설치 X → Flutter/Dart SDK 번들 자동 감지
  --   FVM 사용 시 fvm = true 로 변경
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      flutter_lookup_cmd = "which flutter",
      fvm = false,
      widget_guides = { enabled = true },
      closing_tags = { enabled = true },
      dev_log = { enabled = true, open_cmd = "tabedit" },
      lsp = {
        color = { enabled = true },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = { vim.fn.expand("$HOME/.pub-cache") },
        },
      },
    },
    keys = {
      { "<leader>Fd", "<cmd>FlutterDevices<CR>",       desc = "Flutter: 디바이스 목록" },
      { "<leader>Fr", "<cmd>FlutterRun<CR>",           desc = "Flutter: Run" },
      { "<leader>FH", "<cmd>FlutterReload<CR>",        desc = "Flutter: Hot Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<CR>",       desc = "Flutter: Hot Restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<CR>",          desc = "Flutter: Quit" },
      { "<leader>Fl", "<cmd>FlutterLogClear<CR>",      desc = "Flutter: 로그 지우기" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<CR>", desc = "Flutter: Outline 토글" },
      { "<leader>Fv", "<cmd>FlutterVisualDebug<CR>",   desc = "Flutter: Visual Debug" },
    },
  },
}
