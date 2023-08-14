-- Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bicep",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "http",
      },
    },
  },
}

return M
