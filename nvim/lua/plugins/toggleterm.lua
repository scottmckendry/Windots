return {
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "n" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
        shade_terminals = true,
        direction = "vertical",
        size = 80,
        float_opts = {
            -- Hide border
            border = "none",
        },
    },
}
