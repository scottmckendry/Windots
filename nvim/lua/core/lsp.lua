vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
})

vim.lsp.enable({
    "basedpyright",
    "bashls",
    "bicep",
    "docker_compose_language_service",
    "gopls",
    "html",
    "jsonls",
    "luals",
    "nil_ls",
    "ols",
    "powershell_es",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "templ",
    "terraformls",
    "ts_ls",
    "yamlls",
})
