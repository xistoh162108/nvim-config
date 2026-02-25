-- ~/.config/nvim/lua/plugins/terraform.lua
return {
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    init = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fmt_on_save = 0
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local util = require("lspconfig.util")

      local function tfenv_env()
        local home = (vim.uv or vim.loop).os_homedir()
        local path = os.getenv("PATH") or ""
        local shims = home .. "/.tfenv/shims"
        local bin = home .. "/.tfenv/bin"

        if vim.fn.isdirectory(shims) == 1 and not path:find(shims, 1, true) then
          path = shims .. ":" .. path
        end
        if vim.fn.isdirectory(bin) == 1 and not path:find(bin, 1, true) then
          path = bin .. ":" .. path
        end

        return {
          PATH = path,
          TFENV_AUTO_INSTALL = "true",
          TF_PLUGIN_CACHE_DIR = home .. "/.terraform.d/plugin-cache",
        }
      end

      opts.servers = opts.servers or {}
      opts.servers.terraformls = {
        cmd = { "terraform-ls", "serve" },
        cmd_env = tfenv_env(),
        filetypes = { "terraform", "terraform-vars", "hcl" },
        root_dir = util.root_pattern(".terraform-version", ".tool-versions", "versions.tf", ".terraform", ".git"),
        single_file_support = true,
        settings = { terraform = { path = "terraform" } },
      }

      return opts
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.terraform = { "terraform" }
      return opts
    end,
  },
}
