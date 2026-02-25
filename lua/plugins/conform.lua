return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- C / C++
        c = { "clang_format" },
        cpp = { "clang_format" },

        -- Java
        java = { "google_java_format" },

        -- Python
        -- (안정 버전: imports -> fix -> format)
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },

        -- JS/TS
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },

        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },

      formatters = {
        google_java_format = {
          command = "google-java-format",
          args = { "$FILENAME" }, -- AOSP 원하면 { "--aosp", "$FILENAME" }
          stdin = false,
        },
        terraform_fmt = {
          command = "terraform",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    },
  },
}
