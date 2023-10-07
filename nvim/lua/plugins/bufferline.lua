return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>bp", ":BufferLineTogglePin<CR>",            desc = "Toggle pin" },
        { "<leader>bP", ":BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = {
        options = {
            indicator = { style = "none" },
            buffer_close_icon = "",
            separator_style = { "", "" },
            always_show_bufferline = false,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Explorer",
                    text_align = "center",
                },
            },
        },
    },
}
