return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v1.*",
    ---@type blink.cmp.Config
    opts = {
        cmdline = { completion = { menu = { auto_show = true } } },
        completion = {
            menu = {
                scrollbar = false,
                auto_show = true,
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
                window = {
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
            },
        },
    },
}
