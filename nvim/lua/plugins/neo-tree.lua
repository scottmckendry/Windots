-- Neo-Tree https://github.com/nvim-neo-tree/neo-tree.nvim

local M = {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      bind_to_cwd = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        never_show = {
          ".git"
        }
      }
    }
  }
}

return M
