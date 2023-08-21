-- null-ls https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls = require("null-ls")
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
      }
    end,
  },
}

return M
