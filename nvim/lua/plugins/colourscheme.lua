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
        "scottmckendry/cyberdream.nvim",
        dev = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme cyberdream")
        end,
    },
}
