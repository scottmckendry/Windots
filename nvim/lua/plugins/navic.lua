return {
    "smiteshp/nvim-navic",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        lsp = {
            auto_attach = true,
            -- priority order for attaching LSP servers
            -- to the current buffer
            preference = {
                "html",
                "templ",
            },
        },
        separator = " 󰁔 ",
    },
}
