local size = function()
    return vim.o.columns * 0.5
end

return {
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm size=" .. size() .. "<cr>", desc = "Toggle Terminal", mode = "n" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
        shade_terminals = true,
        direction = "vertical",
        float_opts = {
            -- Hide border
            border = "none",
        },
    },
}
