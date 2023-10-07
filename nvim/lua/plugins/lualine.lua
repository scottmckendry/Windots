return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local get_hlgroup = require("core.utils").get_hlgroup
        local colours = {
            bg = get_hlgroup("Normal").bg,
            fg = "#f8f8f2",
            grey = "#565f89",
            green = "#9ece6a",
            yellow = "#e0af68",
            blue = "#7aa2f7",
            magenta = "#bb9af7",
            red = "#f7768e",
            cyan = "#7dcfff",
            orange = "#ff9e64",
        }
        local copilot_colours = {
            [""] = { fg = colours.grey, bg = colours.bg },
            ["Normal"] = { fg = colours.grey, bg = colours.bg },
            ["Warning"] = { fg = colours.red, bg = colours.bg },
            ["InProgress"] = { fg = colours.yellow, bg = colours.bg },
        }
        return {
            options = {
                component_separators = { left = " ", right = " " },
                theme = {
                    normal = {
                        a = { fg = colours.blue, bg = colours.bg },
                        b = { fg = colours.cyan, bg = colours.bg },
                        c = { fg = colours.fg, bg = colours.bg },
                        x = { fg = colours.fg, bg = colours.bg },
                        y = { fg = colours.magenta, bg = colours.bg },
                        z = { fg = colours.grey, bg = colours.bg },
                    },
                    insert = {
                        a = { fg = colours.green, bg = colours.bg },
                        z = { fg = colours.grey, bg = colours.bg },
                    },
                    visual = {
                        a = { fg = colours.magenta, bg = colours.bg },
                        z = { fg = colours.grey, bg = colours.bg },
                    },
                    terminal = {
                        a = { fg = colours.blue, bg = colours.bg },
                        z = { fg = colours.grey, bg = colours.bg },
                    },
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
                lualine_x = {
                    {
                        function()
                            local icon = " "
                            local status = require("copilot.api").status.data
                            return icon .. (status.message or "")
                        end,
                        cond = function()
                            local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
                            return ok and #clients > 0
                        end,
                        color = function()
                            if not package.loaded["copilot"] then
                                return
                            end
                            local status = require("copilot.api").status.data
                            return copilot_colours[status.status] or copilot_colours[""]
                        end,
                    },
                    { "diff" },
                },
                lualine_y = {
                    {
                        "progress",
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
