return {
    {
        "scottmckendry/cyberdream.nvim",
        dev = true,
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                terminal_colors = false,
                cache = true,
                borderless_telescope = { border = false, style = "flat" },
                theme = {
                    variant = "auto",
                    overrides = function(colours)
                        return {
                            TelescopePromptPrefix = { fg = colours.blue },
                            TelescopeMatching = { fg = colours.cyan },
                            TelescopeResultsTitle = { fg = colours.blue },
                            TelescopePromptCounter = { fg = colours.cyan },
                            TelescopePromptTitle = { fg = colours.bg, bg = colours.blue, bold = true },
                        }
                    end,
                },
            })

            vim.cmd("colorscheme cyberdream")
            vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true })
            vim.api.nvim_create_autocmd("User", {
                pattern = "CyberdreamToggleMode",
                callback = function(ev)
                    print("Switched to " .. ev.data .. " mode!")
                end,
            })
        end,
    },
}
