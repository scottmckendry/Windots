return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
        "nvim-mini/mini.icons",
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        config = function()
            require("mini.icons").setup()
            require("mini.icons").mock_nvim_web_devicons()
        end,
    },
    ---@type snacks.Config
    opts = {
        dashboard = { enabled = true },
        image = { doc = { enabled = true, max_height = vim.o.lines * 0.5, max_width = vim.o.columns * 0.5 } },
        lazygit = { configure = false, win = { position = "float", width = 0.99, height = 0.99 } },
        notifier = { enabled = true },
        picker = { prompt = "   ", formatters = { file = { filename_first = true } } },
        terminal = { win = { position = "right", width = 0.5, wo = { winbar = "" } } },
        words = { enabled = true },
    },
}
