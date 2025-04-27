return {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = "Bilal2453/luvit-meta",
    opts = {
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    },
}
