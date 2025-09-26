return {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    config = function()
        require("mason").setup({
            ui = {
                border = "rounded",
                width = 0.8,
                height = 0.8,
            },
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        })

        local linux_only_pacakages = { "nil" }
        local ignore_on_nixos = { "nil" }
        local mason_packages = {
            "basedpyright",
            "bash-language-server",
            "bicep-lsp",
            "black",
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
            "rzls",
            "shfmt",
            "stylua",
            "tailwindcss-language-server",
            "taplo",
            "templ",
            "terraform-ls",
            "typescript-language-server",
            "yaml-language-server",
        }

        if vim.fn.has("unix") == 1 then
            mason_packages = vim.list_extend(mason_packages, linux_only_pacakages)
            local os = vim.fn.systemlist("grep ^ID= /etc/os-release | cut -d= -f2")[1]
            if os == "nixos" then
                mason_packages = vim.tbl_filter(function(p)
                    return not vim.tbl_contains(ignore_on_nixos, p)
                end, mason_packages)
            end
        end

        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(mason_packages) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end,
}
