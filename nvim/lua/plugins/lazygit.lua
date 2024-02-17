return {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig" },
    keys = {
        { "<leader>gg", ":LazyGit<cr>", silent = true, desc = "LazyGit", mode = "n" },
    },
    config = function()
        vim.g.lazygit_floating_window_border_chars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' } -- no borders
    end,
}
