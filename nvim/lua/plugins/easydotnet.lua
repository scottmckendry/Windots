return {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "razor" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        lsp = {
            auto_refresh_codelens = false,
        },
    },
}
