return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        local TS = require("nvim-treesitter")
        TS.update(nil, { summary = true })
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function(_, opts)
        local TS = require("nvim-treesitter")
        local ensure_installed = {
            "bash",
            "bicep",
            "c_sharp",
            "css",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "html",
            "http",
            "json",
            "just",
            "kdl",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "nix",
            "odin",
            "powershell",
            "python",
            "razor",
            "regex",
            "ron",
            "rust",
            "sql",
            "templ",
            "terraform",
            "toml",
            "typescript",
            "typst",
            "vim",
            "vimdoc",
            "yaml",
        }

        TS.setup(opts)
        local installed = TS.get_installed()
        local to_install = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
        end, ensure_installed or {})

        if #to_install > 0 then
            vim.schedule(function()
                TS.install(to_install, { summary = true })
            end)
        end
    end,
}
