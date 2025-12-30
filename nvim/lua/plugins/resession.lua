return {
    "stevearc/resession.nvim",
    lazy = false,
    dependencies = {
        "scottmckendry/pick-resession.nvim",
        dev = true,
        opts = {
            path_icons = {
                { match = "C:/Users/" .. vim.g.user .. "/git/", icon = " ", highlight = "Changed" },
                { match = "/home/" .. vim.g.user .. "/git/", icon = " ", highlight = "Changed" },
                { match = "C:/Users/" .. vim.g.user .. "/", icon = " ", highlight = "Special" },
                { match = "/home/" .. vim.g.user .. "/", icon = " ", highlight = "Special" },
            },
        },
    },
    opts = {
        autosave = {
            enabled = true,
            interval = 60,
            notify = false,
        },
    },
}
