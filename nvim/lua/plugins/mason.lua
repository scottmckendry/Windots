return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", ":Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
        ensure_installed = {
            "stylua",
            "gopls",
            "goimports-reviser",
            "golines",
            "bicep-lsp",
            "dockerfile-language-server",
            "docker-compose-language-service",
            "powershell-editor-services",
            "ltex-ls",
            "omnisharp",
            "json-lsp",
            "html-lsp",
            "prettier",
        },
        registries = {
            "github:scottmckendry/mason-registry"
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
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
