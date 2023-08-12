-- LSP Config https://github.com/neovim/nvim-lspconfig

local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
local command_fmt =
[[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
local temp_path = vim.fn.stdpath("cache")
local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)

local M = {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {

        -- Go Language Server (gopls)
        gopls = function()
          require("lspconfig").gopls.setup({
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = require("lspconfig/util").root_pattern("go.mod", ".git"),
            settings = {
              gopls = {
                completeUnimported = true,
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
              },
            },
          })
        end,

        -- PowerShell Editor Services
        powershell_es = function()
          require("lspconfig").powershell_es.setup({
            filetypes = { "ps1" },
            bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
            cmd = { "pwsh", "-NoLogo", "-Command", command },
          })
        end,

        -- Azure Pipelines
        azure_pipelines_language_server = function()
          require("lspconfig").azure_pipelines_language_server.setup({
            cmd = { "azure_pipelines_language_server", "--stdio" },
            filetypes = { "yaml" },
            single_file_support = true,
          })
        end,
      },
    },
  },
}

return M
