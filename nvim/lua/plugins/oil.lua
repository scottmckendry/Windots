return {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory with Oil" },
        {
            "_",
            function()
                require("oil.actions").open_cwd.callback()
            end,
            desc = "Open current directory with Oil",
        },
    },
    config = function()
        require("oil").setup({
            default_file_explorer = true,

            columns = {
                "icon",
                "size",
            },
            view_options = {
                show_hidden = true,
            },
        })
    end,
}
