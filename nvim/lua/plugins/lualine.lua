local get_hlgroup = require("core.utils").get_hlgroup
local colours = {
    bg = get_hlgroup("Normal").bg,
    fg = get_hlgroup("Normal").fg,
    light_grey = "#565f89",
    green = "#9ece6a",
    yellow = "#e0af68",
    blue = "#7aa2f7",
    magenta = "#bb9af7",
    red = "#f7768e",
    cyan = "#7dcfff",
    orange = "#ff9e64",
}
return {
    "nvim-lualine/lualine.nvim",
    event = "BufWinEnter",
    opts = function()
        return {
            options = {
                theme = {
                    normal = {
                        a = { fg = colours.blue, bg = colours.bg },
                        b = { fg = colours.cyan, bg = colours.bg },
                        c = { fg = colours.fg, bg = colours.bg },
                        x = { fg = colours.fg, bg = colours.bg },
                        y = { fg = colours.magenta, bg = colours.bg },
                        z = { fg = colours.grey, bg = colours.bg },
                    },
                    insert = { a = { fg = colours.green, bg = colours.bg } },
                    visual = { a = { fg = colours.magenta, bg = colours.bg } },
                    replace = { a = { fg = colours.red, bg = colours.bg } },
                    terminal = { a = { fg = colours.blue, bg = colours.bg } },
                },

                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
                lualine_b = { { "branch", icon = "" } },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = "󰝶 ",
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    {
                        "filename",
                        symbols = { modified = "  ", readonly = "", unnamed = "" }
                    },
                    {
                        function() return require("nvim-navic").get_location() end,
                        cond = function()
                            return package.loaded["nvim-navic"] and
                                require("nvim-navic").is_available()
                        end,
                    },
                },
                lualine_x = { "diff" },
                lualine_y = {
                    {
                        "progress",
                        separator = " ",
                        padding = { left = 1, right = 0 }
                    },
                    {
                        "location",
                        padding = { left = 0, right = 1 }
                    },
                },
                lualine_z = {
                    function()
                        return "  " .. os.date("%X")
                    end,
                },
            },

            extensions = { "lazy" },
        }
    end,
}
