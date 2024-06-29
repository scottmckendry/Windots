return {
    "scottmckendry/dashboard-nvim",
    event = "VimEnter",
    dev = true,
    config = function()
        vim.cmd("highlight DashboardHeader guifg=#ffffff")
        require("dashboard").setup({
            theme = "hyper",
            hide = {
                statusline = false,
            },
            config = {
                week_header = { enable = true },
                shortcut = {
                    {
                        icon = "󰒲  ",
                        icon_hl = "Boolean",
                        desc = "Update ",
                        group = "Directory",
                        action = "Lazy update",
                        key = "u",
                    },
                    {
                        icon = "   ",
                        icon_hl = "Boolean",
                        desc = "Files ",
                        group = "Statement",
                        action = "Telescope find_files",
                        key = "f",
                    },
                    {
                        icon = "   ",
                        icon_hl = "Boolean",
                        desc = "Recent ",
                        group = "String",
                        action = "Telescope oldfiles",
                        key = "r",
                    },
                    {
                        icon = "   ",
                        icon_hl = "Boolean",
                        desc = "Grep ",
                        group = "ErrorMsg",
                        action = "Telescope live_grep",
                        key = "g",
                    },
                    {
                        icon = "   ",
                        icon_hl = "Boolean",
                        desc = "Quit ",
                        group = "WarningMsg",
                        action = "qall!",
                        key = "q",
                    },
                },
                project = { enable = false },
                mru = { enable = false },
                footer = {},
            },
        })
    end,
}
