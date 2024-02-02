return {
    "scottmckendry/dashboard-nvim",
    dependencies = { "m00qek/baleia.nvim" },
    event = "VimEnter",
    dev = true,
    config = function()
        local logo = [[
▀▄   ▄▀      ▄▄▄████▄▄▄      ▄██▄       ▀▄   ▄▀      ▄▄▄████▄▄▄      ▄██▄
 ▄█▀███▀█▄    ███▀▀██▀▀███   ▄█▀██▀█▄    ▄█▀███▀█▄    ███▀▀██▀▀███   ▄█▀██▀█▄
█▀███████▀█   ▀▀███▀▀███▀▀   ▀█▀██▀█▀   █▀███████▀█   ▀▀███▀▀███▀▀   ▀█▀██▀█▀
▀ ▀▄▄ ▄▄▀ ▀    ▀█▄ ▀▀ ▄█▀    ▀▄    ▄▀   ▀ ▀▄▄ ▄▄▀ ▀    ▀█▄ ▀▀ ▄█▀    ▀▄    ▄▀

▄ ▀▄   ▄▀ ▄    ▄▄▄████▄▄▄      ▄██▄     ▄ ▀▄   ▄▀ ▄    ▄▄▄████▄▄▄      ▄██▄  
█▄█▀███▀█▄█   ███▀▀██▀▀███   ▄█▀██▀█▄   █▄█▀███▀█▄█   ███▀▀██▀▀███   ▄█▀██▀█▄
▀█████████▀   ▀▀▀██▀▀██▀▀▀   ▀▀█▀▀█▀▀   ▀█████████▀   ▀▀▀██▀▀██▀▀▀   ▀▀█▀▀█▀▀
 ▄▀     ▀▄    ▄▄▀▀ ▀▀ ▀▀▄▄   ▄▀▄▀▀▄▀▄    ▄▀     ▀▄    ▄▄▀▀ ▀▀ ▀▀▄▄   ▄▀▄▀▀▄▀▄
]]
        logo = vim.split(logo, "\n")
        local header = { os.date("%A, %d %B %Y"), os.date("%I:%M %p"), "" }
        for _, elm in ipairs(header) do
            table.insert(logo, elm)
        end

        -- Override DashboardHeader Highlight
        vim.cmd("highlight DashboardHeader guifg=#ffffff")
        require("dashboard").setup({
            theme = "hyper",
            hide = {
                statusline = false,
            },
            config = {
                header = logo,
                shortcut = {
                    {
                        icon = "󰒲  ",
                        icon_hl = "DiffChange",
                        desc = "Update ",
                        group = "Directory",
                        action = "Lazy update",
                        key = "u",
                    },
                    {
                        icon = "   ",
                        icon_hl = "DiffChange",
                        desc = "Files ",
                        group = "Statement",
                        action = "require('core.telescopePickers').prettyFilesPicker({ picker = 'find_files' })",
                        key = "f",
                    },
                    {
                        icon = "   ",
                        icon_hl = "DiffChange",
                        desc = "Recent ",
                        group = "DiffAdd",
                        action = "require('core.telescopePickers').prettyFilesPicker({ picker = 'oldfiles' })",
                        key = "r",
                    },
                    {
                        icon = "   ",
                        icon_hl = "DiffChange",
                        desc = "Grep ",
                        group = "DiffDelete",
                        action = "require('core.telescopePickers').prettyGrepPicker({ picker = 'live_grep' })",
                        key = "g",
                    },
                    {
                        icon = "   ",
                        icon_hl = "DiffChange",
                        desc = "Quit ",
                        group = "WarningMsg",
                        action = "qall!",
                        key = "q",
                    },
                },
                project = { enable = false },
                mru = { enable = false },
                footer = { "“If the only tool you have is a hammer, everything looks like a nail”" },
            },
        })
    end,
}
