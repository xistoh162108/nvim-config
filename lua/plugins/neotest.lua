return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      -- 언어별 어댑터
      "nvim-neotest/neotest-python",   -- pytest / unittest
      "nvim-neotest/neotest-jest",     -- Jest (JS/TS)
    },
    keys = {
      -- <leader>T 프리픽스 (tf/ts/tt는 terminal/colorscheme에서 사용 중)
      {
        "<leader>Tr",
        function() require("neotest").run.run() end,
        desc = "Test: Run nearest",
      },
      {
        "<leader>Tf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Test: Run file",
      },
      {
        "<leader>Ts",
        function() require("neotest").summary.toggle() end,
        desc = "Test: Summary",
      },
      {
        "<leader>To",
        function() require("neotest").output_panel.toggle() end,
        desc = "Test: Output panel",
      },
      {
        "<leader>Tx",
        function() require("neotest").run.stop() end,
        desc = "Test: Stop",
      },
      {
        "<leader>Td",
        function() require("neotest").run.run({ strategy = "dap" }) end,
        desc = "Test: Debug nearest",
      },
      {
        "]T",
        function() require("neotest").jump.next({ status = "failed" }) end,
        desc = "Next failed test",
      },
      {
        "[T",
        function() require("neotest").jump.prev({ status = "failed" }) end,
        desc = "Prev failed test",
      },
    },
    config = function()
      require("neotest").setup({
        discovery = { enabled = false }, -- 대규모 ML 프로젝트에서 성능 향상
        diagnostic = { enabled = true },
        adapters = {
          require("neotest-python")({
            runner = "pytest",
            python = function()
              -- venv-selector와 연동: 활성 venv의 python 우선 사용
              local venv = vim.env.VIRTUAL_ENV
              if venv then
                return venv .. "/bin/python"
              end
              return "python3"
            end,
          }),
          require("neotest-jest")({
            jestCommand = "npx jest",
            jestConfigFile = function()
              -- 프로젝트 루트의 jest.config.* 자동 탐지
              local file = vim.fn.expand("%:p")
              local root = vim.fn.fnamemodify(
                vim.fn.findfile("jest.config.js", file .. ";"),
                ":p:h"
              )
              if root ~= "" then
                return root .. "/jest.config.js"
              end
            end,
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
        },
      })
    end,
  },
}
