-- Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    ensure_installed = {
      "bicep",
      "go",
      "gomod",
    },
  },
}

return M
