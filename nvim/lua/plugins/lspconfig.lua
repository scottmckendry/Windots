-- LSP Config https://github.com/neovim/nvim-lspconfig

local M = {
  {
    "neovim/nvim-lspconfig",
    opts = {
      config = function()
        require("lspconfig").gopls.setup({
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = require("lspconfig/util").root_pattern("go.mod", ".git"),
          settings = {
            gopls = {
              compleUnimported = true,
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        })
      end,
    },
  },
}

return M
