return {
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm size=20<cr>", desc = "Toggle Terminal", mode = "n" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>",         desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
        shade_terminals = false,
        float_opts = {
            -- Hide border
            border = "none",
        },
    },
}
