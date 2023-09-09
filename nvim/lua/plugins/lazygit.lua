return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit", mode = "n" },
  },
  config = function()
    vim.g.lazygit_floating_window_border_chars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
  end,
}
