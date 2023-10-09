return {
    {
        "folke/noice.nvim",
        dependencies = {
            "rcarriga/nvim-notify",
            "MunifTanjim/nui.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            any = {
                                { find = "%d+L, %d+B" },
                                { find = "; after #%d+" },
                                { find = "; before #%d+" },
                            },
                        },
                        view = "mini",
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = true,
                },

                views = {
                    mini = {
                        win_options = {
                            winblend = 0,
                        },
                    },
                },
            })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#bb9af7", bg = "none" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#7dcfff", bg = "none" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupIcon", { fg = "#7dcfff", bg = "none" })
        end,
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
}
