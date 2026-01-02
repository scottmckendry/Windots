return {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            css = { "prettier" },
            go = { "goimports_reviser", "gofmt" },
            html = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            nix = { "nixfmt" },
            python = { "black" },
            rust = { "rustfmt" },
            scss = { "prettier" },
            sh = { "shfmt" },
            templ = { "templ" },
            toml = { "taplo" },
            typst = { "typstyle" },
            yaml = { "prettier" },
        },

        format_after_save = function()
            --- @diagnostic disable-next-line: unnecessary-if
            if not vim.g.autoformat then
                return
            else
                if vim.bo.filetype == "ps1" then
                    vim.lsp.buf.format()
                    return
                end
                ---@diagnostic disable-next-line: return-type-mismatch
                return { lsp_format = "fallback", async = true }
            end
        end,

        formatters = {
            goimports_reviser = {
                command = "goimports-reviser",
                args = { "-output", "stdout", "$FILENAME" },
            },
        },
    },
}
