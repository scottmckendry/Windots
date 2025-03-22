return {
    "stevearc/resession.nvim",
    dependencies = {
        {
            "scottmckendry/pick-resession.nvim",
            dev = true,
            config = function()
                require("pick-resession").setup({
                    path_icons = {
                        { match = "C:/Users/scott/git/", icon = " ", highlight = "Changed" },
                        { match = "/home/scott/git/", icon = " ", highlight = "Changed" },
                        { match = "C:/Users/scott/", icon = " ", highlight = "Special" },
                        { match = "/home/scott/", icon = " ", highlight = "Special" },
                    },
                })
            end,
        },
    },
    lazy = false,
    config = function()
        local resession = require("resession")
        resession.setup({
            autosave = {
                enabled = true,
                interval = 60,
                notify = false,
            },
        })
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Only load the session if nvim was started with no args
                if vim.fn.argc(-1) == 0 then
                    -- Save these to a different directory, so our manual sessions don't get polluted
                    resession.load(vim.fn.getcwd(), { silence_errors = true })
                end
            end,
            nested = true,
        })
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                resession.save(vim.fn.getcwd(), { notify = true })
            end,
        })
    end,
}
