return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
        "echasnovski/mini.icons",
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        config = function()
            require("mini.icons").setup()
            require("mini.icons").mock_nvim_web_devicons()
        end,
    },
    config = function()
        require("snacks").setup({
            notifier = { enabled = true },
            words = { enabled = true },
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
            picker = {
                formatters = {
                    file = {
                        filename_first = true,
                    },
                },
                prompt = "   ",
            },
            dashboard = {},
        })
    end,
}
