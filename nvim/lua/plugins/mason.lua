-- Mason https://github.com/williamboman/mason.nvim

local M = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "azure-pipelines-language-server",
        "gopls",
        "powershell_editor_services",
        "bicep-lsp",
      },
    },
  },
}

return M
