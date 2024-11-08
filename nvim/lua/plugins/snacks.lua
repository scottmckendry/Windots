return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("snacks").setup({
            lazygit = {
                configure = false,
                win = {
                    position = "float",
                    width = 0.99,
                    height = 0.99,
                },
            },
            terminal = {
                win = {
                    position = "right",
                    width = 0.5,
                    wo = {
                        winbar = "", -- hide terminal title
                    },
                },
            },
        })
    end,
}
