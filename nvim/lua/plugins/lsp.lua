return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "gopls",
        "goimports-reviser",
        "golines",
        "golangci-lint",
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
          require("lspconfig").powershell_es.setup({})
        end,

        -- Dockerfile
        dockerls = function()
          require("lspconfig").dockerls.setup({})
        end,

        -- Docker Compose
        docker_compose_language_service = function()
          require("lspconfig").docker_compose_language_service.setup({})
        end,
      },
    },
  },

  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function()
  --     return {
  --       sources = {
  --         null_ls.builtins.formatting.gofmt,
  --         null_ls.builtins.formatting.goimports_reviser,
  --         null_ls.builtins.formatting.golines,
  --       },
  --     }
  --   end,
  -- },

  {
    "nvimdev/guard.nvim",
    event = "BufReadPre",
    config = function()
      local ft = require("guard.filetype")

      ft("go")
          :fmt({
            cmd = "goimports-reviser",
            args = { "-output", "stdout" },
            fname = true,
          })
          :append({
            cmd = "gofmt",
            stdin = true,
          })
          :append({
            cmd = "golines",
            stdin = true,
          })

      require("guard").setup({
        -- the only options for the setup function
        fmt_on_save = true,
        -- Use lsp if no formatter was defined for this filetype
        lsp_as_default_formatter = false,
      })
    end,
  },
}
