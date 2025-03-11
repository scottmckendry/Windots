return {
    "seblj/roslyn.nvim",
    ft = { "cs", "razor" },
    init = function()
        vim.filetype.add({
            extension = {
                razor = "razor",
                cshtml = "razor",
            },
        })
    end,
    config = function()
        require("roslyn").setup({})
    end,
}
