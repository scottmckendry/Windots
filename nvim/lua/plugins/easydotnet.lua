return {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "razor" },
    config = function()
        require("easy-dotnet").setup()
    end,
}
