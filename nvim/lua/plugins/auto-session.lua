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
        local close_minifiles = function()
            require("mini.files").close()
        end

        require("auto-session").setup({
            session_lens = {
                winblend = 0,
            },

            pre_save_cmds = {
                close_minifiles,
            },
        })
    end,
}
