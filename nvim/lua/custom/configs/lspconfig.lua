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

local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
local command_fmt = [[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
local temp_path = vim.fn.stdpath("cache")
local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)
lspconfig.powershell_es.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "ps1" },
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
  cmd = { "pwsh", "-NoLogo", "-Command", command },
}

local bicep_bin = vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/extension/BicepLanguageServer/Bicep.LangServer.dll"
lspconfig.bicep.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "bicep", "bicepparam" },
  cmd = { "dotnet", bicep_bin },
}
