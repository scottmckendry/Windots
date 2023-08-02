local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.powershell_es.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "ps1" },
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
}

local bicep_bin = vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/extension/BicepLanguageServer/Bicep.LangServer.dll"
lspconfig.bicep.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "bicep", "bicepparam" },
  cmd = { "dotnet", bicep_bin },
}
