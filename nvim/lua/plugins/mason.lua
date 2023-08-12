-- Mason https://github.com/williamboman/mason.nvim

local M = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "gopls",
        "bicep-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service"
      },
    },
  },
}

return M
