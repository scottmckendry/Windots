-- null-ls https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local M = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      return {
        sources = {
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.formatting.golines,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  timeout_ms = 4000,
                })
              end,
            })
          end
        end,
      }
    end,
  },
}

return M
