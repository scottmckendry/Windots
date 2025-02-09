return {
    "scottmckendry/cyberdream.nvim",
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            variant = "auto",
            transparent = true,
            italic_comments = true,
            hide_fillchars = true,
            terminal_colors = false,
            cache = true,
            borderless_pickers = true,
            overrides = function(c)
                return {
                    CursorLine = { bg = c.bg },
                    CursorLineNr = { fg = c.magenta },

                    MiniStatuslineModeCommand = { fg = c.yellow, bold = true },
                    MiniStatuslineModeInsert = { fg = c.green, bold = true },
                    MiniStatuslineModeNormal = { fg = c.blue, bold = true },
                    MiniStatuslineModeOther = { fg = c.cyan, bold = true },
                    MiniStatuslineModeReplace = { fg = c.red, bold = true },
                    MiniStatuslineModeVisual = { fg = c.magenta, bold = true },
                }
            end,
        })

        vim.cmd("colorscheme cyberdream")
    end,
}
