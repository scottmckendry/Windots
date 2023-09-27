-- Set transparency
local is_transparent = false
if vim.fn.has("unix") == 1 then
    is_transparent = true
end

return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = is_transparent,
                }
            })
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
    }
}
