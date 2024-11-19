return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    config = function()
        require("blink.cmp").setup({
            windows = {
                autocomplete = {
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
