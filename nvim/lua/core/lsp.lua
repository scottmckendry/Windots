vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
})

-- Add mason binaries to PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

vim.lsp.enable({
    "basedpyright",
    "bashls",
    "bicep",
    "docker_compose_language_service",
    "emmylua_ls",
    "gopls",
    "html",
    "jsonls",
    "nil_ls",
    "ols",
    "powershell_es",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "templ",
    "terraformls",
    "tinymist",
    "ts_ls",
    "yamlls",
})
