return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        ---@type NoiceConfig
        opts = {
            presets = { bottom_search = true, lsp_doc_border = true },
            cmdline = { view = "cmdline" },
            views = { mini = { win_options = { winblend = 0 } } },
        },
    },
}
