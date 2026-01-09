return {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    build = ":MasonUpdate",
    ---@type MasonSettings
    opts = {
        ui = {
            border = "rounded",
            width = 0.8,
            height = 0.8,
        },
        registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mason_packages = {
            "basedpyright",
            "bash-language-server",
            "bicep-lsp",
            "black",
            "copilot-language-server",
            "emmylua_ls",
            "goimports-reviser",
            "golines",
            "gopls",
            "html-lsp",
            "jq",
            "json-lsp",
            "lua-language-server",
            "markdownlint-cli2",
            "ols",
            "powershell-editor-services",
            "prettier",
            "roslyn",
            "rust-analyzer",
            "shfmt",
            "stylua",
            "tailwindcss-language-server",
            "taplo",
            "templ",
            "terraform-ls",
            "tinymist",
            "tree-sitter-cli",
            "typescript-language-server",
            "typstyle",
            "yaml-language-server",
        }

        local mr = require("mason-registry")

        local function ensure_installed()
            for _, tool in ipairs(mason_packages) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
            -- auto uninstall unreferenced packages
            for _, tool in ipairs(mr.get_installed_package_names()) do
                if not vim.tbl_contains(mason_packages, tool) then
                    local p = mr.get_package(tool)
                    p:uninstall()
                end
            end
        end

        vim.defer_fn(function()
            mr.refresh(ensure_installed)
        end, 10)
    end,
}
