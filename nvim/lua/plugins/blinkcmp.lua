return {
    "saghen/blink.cmp",
    dev = true,
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
                autocomplete = {
                    draw = "reversed",
                    border = {
                        { "󱐋", "WarningMsg" },
                        "─",
                        "╮",
                        "│",
                        "╯",
                        "─",
                        "╰",
                        "│",
                    },
                },
                documentation = {
                    auto_show = true,
                    border = {
                        { "", "DiagnosticHint" },
                        "─",
                        "╮",
                        "│",
                        "╯",
                        "─",
                        "╰",
                        "│",
                    },
                },
                signature_help = { border = "rounded" },
            },
        })
    end,
}
