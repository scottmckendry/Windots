return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "smiteshp/nvim-navic",
    },
    config = function()
        -- vim.lsp.set_log_level("trace")
        -- require("vim.lsp.log").set_format_func(vim.inspect)

        -- Go
        require("lspconfig").gopls.setup({
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

        -- HTML
        require("lspconfig").html.setup({})

        -- Tailwind CSS
        require("lspconfig").tailwindcss.setup({})

        -- YAML
        require("lspconfig").yamlls.setup({})

        -- Lua
        require("lspconfig").lua_ls.setup({
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                    client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                        },
                    })

                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
                return true
            end,
        })

        -- PowerShell
        local mason_registry = require("mason-registry")
        local bundle_path = mason_registry.get_package("powershell-editor-services"):get_install_path()
        require("lspconfig").powershell_es.setup({
            bundle_path = bundle_path,
            init_options = {
                enableProfileLoading = false,
            },
        })

        -- Ltex LS (LanguageTool)
        local ltex_cmd = vim.fn.stdpath("data") .. "/mason/packages/ltex-ls/ltex-ls-16.0.0/bin/ltex-ls"
        require("lspconfig").ltex.setup({
            cmd = { ltex_cmd },
            settings = {
                ltex = {
                    checkFrequency = "save",
                    language = "en-GB",
                },
            },
        })
    end,
}
