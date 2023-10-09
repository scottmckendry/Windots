-- Set transparency
local is_transparent = true -- Set to false to disable transparency in 🪟
if vim.fn.has("unix") == 1 then
    is_transparent = true
end

if is_transparent then
    vim.opt.fillchars:append({
        horiz = " ",
        horizup = " ",
        horizdown = " ",
        vert = " ",
        vertleft = " ",
        vertright = " ",
        verthoriz = " ",
        eob = " ",
    })
end

return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            if is_transparent then
                require("nightfox").setup({
                    options = {
                        transparent = true,
                    },
                    groups = {
                        all = {
                            NormalFloat = { fg = "fg1", bg = "NONE" },
                            WhichKeyFloat = { fg = "fg1", bg = "NONE" },
                        },
                    },
                })
            end
            vim.cmd("colorscheme carbonfox")
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            if is_transparent then
                require("tokyonight").setup({
                    transparent = true,
                    styles = {
                        sidebars = "transparent",
                        floats = "transparent",
                    },
                })
            end
            -- vim.cmd("colorscheme tokyonight-night")
        end,
    },
}
