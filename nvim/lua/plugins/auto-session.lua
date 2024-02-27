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
        local close_neotree = function()
            require("neo-tree.sources.manager").close_all()
        end

        require("auto-session").setup({
            session_lens = {
                winblend = 0,
            },

            pre_save_cmds = {
                close_neotree,
            },
        })
    end,
}
