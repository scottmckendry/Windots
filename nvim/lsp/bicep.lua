--- @type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/bicep-lsp" },
    filetypes = { "bicep", "bicep-params" },
    root_markers = { ".git" },
    init_options = {},
}
