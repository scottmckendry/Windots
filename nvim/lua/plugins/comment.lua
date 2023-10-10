return {
    "numToStr/comment.nvim",
    event = "BufReadPre",
    config = function()
        require("Comment").setup()
    end,
}
