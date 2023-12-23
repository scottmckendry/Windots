return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local colors = require("cyberdream.colors").default
        local copilot_colors = {
            [""] = { fg = colors.grey, bg = colors.none },
            ["Normal"] = { fg = colors.grey, bg = colors.none },
            ["Warning"] = { fg = colors.red, bg = colors.none },
            ["InProgress"] = { fg = colors.yellow, bg = colors.none },
        }
        return {
            options = {
                component_separators = { left = " ", right = " " },
                theme = {
                    normal = {
                        a = { fg = colors.blue, bg = colors.none },
                        b = { fg = colors.cyan, bg = colors.none },
                        c = { fg = colors.fg, bg = colors.none },
                        x = { fg = colors.fg, bg = colors.none },
                        y = { fg = colors.magenta, bg = colors.none },
                        z = { fg = colors.grey, bg = colors.none },
                    },
                    insert = {
                        a = { fg = colors.green, bg = colors.none },
                        z = { fg = colors.grey, bg = colors.none },
                    },
                    visual = {
                        a = { fg = colors.magenta, bg = colors.none },
                        z = { fg = colors.grey, bg = colors.none },
                    },
                    terminal = {
                        a = { fg = colors.orange, bg = colors.none },
                        z = { fg = colors.grey, bg = colors.none },
                    },
                },

                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
                lualine_b = { { "branch", icon = "" } },
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
                        symbols = { modified = "  ", readonly = "", unnamed = "" },
                    },
                    {
                        function()
                            return require("nvim-navic").get_location()
                        end,
                        cond = function()
                            return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                        end,
                        color = { fg = colors.grey, bg = colors.none },
                    },
                },
                lualine_x = {
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = colors.green },
                    },
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
                            return copilot_colors[status.status] or copilot_colors[""]
                        end,
                    },
                    { "diff" },
                },
                lualine_y = {
                    {
                        "progress",
                    },
                    {
                        "location",
                        color = { fg = colors.cyan, bg = colors.none },
                    },
                },
                lualine_z = {
                    function()
                        return "  " .. os.date("%X") .. " 📎"
                    end,
                },
            },

            extensions = { "lazy" },
        }
    end,
}
