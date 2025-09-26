--- @type vim.lsp.Config
return {
    cmd = { "ols" },
    filetypes = { "odin" },
    root_markers = { ".git", "main.odin" },
    init_options = {
        checker_args = "-vet -strict-style",
        enable_references = true,
    },
}
