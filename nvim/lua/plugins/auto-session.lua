return {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
        {
            "<leader>fS",
            function()
                require("auto-session.session-lens").search_session()
            end,
            desc = "Find neovim session",
        },
    },
    config = function()
        require("auto-session").setup({
            session_lens = {
                winblend = 0,
            },
        })
    end,
}
