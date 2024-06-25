return {
    "Aasim-A/scrollEOF.nvim",
    event = "BufRead",
    config = function()
        require("scrollEOF").setup({
            disabled_filetypes = {
                "minifiles",
            },
        })
    end,
}
