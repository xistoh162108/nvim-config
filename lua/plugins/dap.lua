-- ~/.config/nvim/lua/plugins/dap.lua
-- Node/JS/TS 디버깅 + C/C++/Rust(codelldb) + DAP UI/virtual text + mason 자동설치
-- LazyVim 환경에서 그대로 넣어도 동작하는 “전체 파일” 버전

return {
  -- 1) Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "DAP REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP Run last",
      },
    },
    config = function()
      local dap = require("dap")

      ---------------------------------------------------------------------------
      -- Custom Breakpoint Icons & Colors (Improves Visibility)
      ---------------------------------------------------------------------------
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#f7768e" }) -- Red
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#7dcfff" })   -- Blue
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ece6a" })    -- Green

      local dap_signs = {
        Breakpoint = { text = "🔴", texthl = "DapBreakpoint" },
        BreakpointCondition = { text = "🔶", texthl = "DapBreakpoint" },
        BreakpointRejected = { text = "⚪", texthl = "DapBreakpoint" },
        LogPoint = { text = "📜", texthl = "DapLogPoint" },
        Stopped = { text = "👉", texthl = "DapStopped", linehl = "CursorLine" },
      }

      for name, sign in pairs(dap_signs) do
        vim.fn.sign_define("Dap" .. name, sign)
      end

      ---------------------------------------------------------------------------
      -- Helpers
      ---------------------------------------------------------------------------
      local function pick_program()
        return vim.fn.input("Program (file): ", vim.fn.getcwd() .. "/", "file")
      end

      ---------------------------------------------------------------------------
      -- C/C++/Rust: codelldb adapter (via mason)
      -- NOTE: mason-nvim-dap가 자동으로 adapter를 잡아주기도 하지만,
      --       mac에서 liblldb 경로/호환 문제를 줄이기 위해 명시적으로 세팅.
      ---------------------------------------------------------------------------
      -- C/C++/Rust: codelldb adapter (Mason 2.x 대응: get_install_path() 없음)
      local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      local extension_path = mason_pkg .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"

      -- 파일이 실제로 존재할 때만 등록 (없으면 조용히 스킵)
      if vim.fn.executable(codelldb_path) == 1 or vim.loop.fs_stat(codelldb_path) then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
            env = {
              LLDB_LIBRARY_PATH = extension_path .. "lldb/lib",
              DYLD_LIBRARY_PATH = extension_path .. "lldb/lib",
            },
          },
        }

        dap.configurations.cpp = {
          {
            name = "C++: Launch (codelldb)",
            type = "codelldb",
            request = "launch",
            program = pick_program,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
      end
      ---------------------------------------------------------------------------
      -- Node / Next / Jest templates (pwa-node)
      -- js-debug-adapter를 mason으로 설치하면 adapter 이름이 보통 pwa-node
      ---------------------------------------------------------------------------
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: pick program",
          program = pick_program,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach: pick process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        -- Next.js dev를 "launch"로 바로 띄우고 싶을 때 (npm script)
        {
          type = "pwa-node",
          request = "launch",
          name = "Next.js: dev (npm run dev)",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          sourceMaps = true,
        },
        -- Jest 디버그(느려도 확실히): runInBand
        {
          type = "pwa-node",
          request = "launch",
          name = "Jest: current file (runInBand)",
          runtimeExecutable = "node",
          runtimeArgs = {
            "--inspect-brk",
            "./node_modules/.bin/jest",
            "${file}",
            "--runInBand",
          },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          sourceMaps = true,
          disableOptimisticBPs = true,
        },
      }

      ---------------------------------------------------------------------------
      -- Python: Remote Attach (ML/AI GPU Servers)
      ---------------------------------------------------------------------------
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = vim.env.VIRTUAL_ENV
            if venv then
              return venv .. "/bin/python"
            end
            return "python3"
          end,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach: Remote (debugpy)",
          connect = function()
            local host = vim.fn.input("Host [127.0.0.1]: ")
            host = host ~= "" and host or "127.0.0.1"
            local port = tonumber(vim.fn.input("Port [5678]: "))
            port = port or 5678
            return { host = host, port = port }
          end,
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript
    end,
  },

  -- 2) DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- 3) Virtual text
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" }, opts = {} },

  -- 4) mason-nvim-dap: 디버거 자동 설치/세팅
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      automatic_setup = true,
      ensure_installed = {
        "js-debug-adapter", -- pwa-node/pwa-chrome
        "codelldb", -- C/C++/Rust
      },
    },
  },
}
