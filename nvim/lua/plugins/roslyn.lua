return {
    "seblj/roslyn.nvim",
    ft = { "cs" },
    config = function()
        require("roslyn").setup({})
    end,
}
