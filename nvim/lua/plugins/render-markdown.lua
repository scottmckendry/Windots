return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    config = function()
        require("render-markdown").setup({
            pipe_table = {
                border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
            },
            code = {
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },
        })
    end,
}
