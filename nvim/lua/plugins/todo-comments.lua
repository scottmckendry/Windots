return {
    "folke/todo-comments.nvim",
    cmd = "TodoTelescope",
    event = "BufRead",
    keys = {
        { "<leader>fd", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
    config = function()
        require("todo-comments").setup()
    end,
}
