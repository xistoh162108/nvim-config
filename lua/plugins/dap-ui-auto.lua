return {
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- dap-ui가 보통 요구(없으면 오류날 수 있음)
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)

      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_auto"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_auto"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_auto"] = function()
        dapui.close()
      end
    end,
  },
}
