return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
        "mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- Go
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

        -- Bicep
        local bicep_path = vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/bicep-lsp.cmd"
        require("lspconfig").bicep.setup({
            cmd = { bicep_path },
        })

        -- Dockerfile
        require("lspconfig").dockerls.setup({})

        -- Docker Compose
        require("lspconfig").docker_compose_language_service.setup({})

        -- C#
        local omnisharp_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/omnisharp.dll"
        require("lspconfig").omnisharp.setup({
            cmd = { "dotnet", omnisharp_path },
            enable_ms_build_load_projects_on_demand = true,
        })

        -- JSON
        require("lspconfig").jsonls.setup({})

        -- Lua
        require("lspconfig").lua_ls.setup {
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT'
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true)
                            }
                        }
                    })

                    client.notify("workspace/didChangeConfiguration",
                        { settings = client.config.settings })
                end
                return true
            end
        }

        -- PowerShell
        local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
        local temp_path = vim.fn.stdpath "cache"
        local command_fmt =
        [[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Verbose]]
        local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)
        require("lspconfig").powershell_es.setup({
            cmd = { "pwsh", "-NoLogo", "-Command", command },
        })

        -- Ltex LS (LanguageTool)
        local ltex_cmd = vim.fn.stdpath("data") .. "/mason/packages/ltex-ls/ltex-ls-16.0.0/bin/ltex-ls"
        require("lspconfig").ltex.setup({
            cmd = { ltex_cmd },
            settings = {
                ltex = {
                    language = "en-GB",
                }
            }
        })
    end
}
