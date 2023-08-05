-- Mason https://github.com/williamboman/mason.nvim

local M = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "azure-pipelines-language-server",
        "gopls",
        "bicep-lsp",
      },
    },
  },
}

return M
