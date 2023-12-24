-- Set transparency
local is_transparent = true -- Set to false to disable transparency in 🪟
if vim.fn.has("unix") == 1 then
    is_transparent = true
end

return {
    {
        "scottmckendry/cyberdream.nvim",
        dev = true,
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = is_transparent,
                italic_comments = true,
                hide_fillchars = true,
            })
            vim.cmd("colorscheme cyberdream")
        end,
    },
}
