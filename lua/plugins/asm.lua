-- lua/plugins/asm.lua
-- Assembly Specialist Integration (asm-lsp)
--   Essential for System Programming and Security courses.

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.asm_lsp = {
        -- asm-lsp must be installed: mason.nvim will handle it or `cargo install asm-lsp`
        filetypes = { "asm", "s", "S" },
        root_dir = require("lspconfig.util").root_pattern(".git", ".asm-lsp.toml"),
      }
      return opts
    end,
  },
}
