return {
    "akinsho/toggleterm.nvim",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "n" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
        shade_terminals = true,
        direction = "vertical",
        size = vim.o.columns * 0.5,
    },
}
