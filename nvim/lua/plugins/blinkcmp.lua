---@diagnostic disable: missing-fields
return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    config = function()
        require("blink.cmp").setup({
            completion = {
                menu = {
                    scrollbar = false,
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
        })
    end,
}
