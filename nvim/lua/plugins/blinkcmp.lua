---@diagnostic disable: missing-fields
return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    config = function()
        local is_enabled = function()
            local disabled_ft = {
                "TelescopePrompt",
                "grug-far",
            }
            return not vim.tbl_contains(disabled_ft, vim.bo.filetype)
                and vim.b.completion ~= false
                and vim.bo.buftype ~= "prompt"
        end

        require("blink.cmp").setup({
            enabled = is_enabled,
            completion = {
                menu = {
                    scrollbar = false,
                    auto_show = is_enabled,
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
