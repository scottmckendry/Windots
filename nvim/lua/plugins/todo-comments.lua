return {
    "folke/todo-comments.nvim",
    cmd = "TodoTelescope",
    event = "BufRead",
    keys = {
        {
            "<leader>fd",
            function()
                Snacks.picker.todo_comments()
            end,
            desc = "Todo",
        },
    },
    config = function()
        require("todo-comments").setup()
    end,
}
