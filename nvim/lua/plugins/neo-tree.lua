return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    keys = {
        { "<leader>ee", ":Neotree toggle<CR>", desc = "Toggle file explorer", silent = true },
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
        })
    end,
}
