return {
    "saghen/blink.cmp",
    -- dev = true,
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    build = "cargo build --release",
    config = function()
        require("blink.cmp").setup({
            keymap = {
                accept = "<C-y>",
                select_next = "<C-n>",
            },
            windows = {
                autocomplete = { border = "rounded", draw = "reversed" },
                documentation = { border = "rounded", auto_show = true },
                signature_help = { border = "rounded" },
            },
            fuzzy = {
                use_frecency = false,
                use_proximity = false,
                sorts = {},
            },
        })
    end,
}
