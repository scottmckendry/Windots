local null_ls = require("null-ls")
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "gopls",
        "goimports-reviser",
        "golines",
        "bicep-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "powershell-editor-services",
      },
    },
  },

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

  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {

        -- Go Language Server (gopls)
        gopls = function()
          require("lspconfig").gopls.setup({
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = require("lspconfig/util").root_pattern("go.mod", ".git"),
            settings = {
              gopls = {
                completeUnimported = true,
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
              },
            },
          })
        end,

        -- PowerShell Editor Services
        powershell_es = function()
          require "lspconfig".powershell_es.setup {}
        end,

        -- Dockerfile
        dockerls = function()
          require 'lspconfig'.dockerls.setup {}
        end,

        -- Docker Compose
        docker_compose_language_service = function()
          require 'lspconfig'.docker_compose_language_service.setup {}
        end,
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      return {
        sources = {
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.formatting.golines,
        },
      }
    end,
  },
}
