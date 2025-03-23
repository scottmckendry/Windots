return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    config = function()
        require("render-markdown").setup({
            completions = { lsp = { enabled = true } },
            pipe_table = {
                border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
            },
            code = {
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },
            bullet = {
                left_pad = 0,
                right_pad = 1,
            },
        })
    end,
}
