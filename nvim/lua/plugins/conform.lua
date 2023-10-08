return {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                go = { "goimports_reviser", "gofmt", "golines" },
                lua = { "stylua" },
                html = { "prettier" },
                javascript = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
            },

            format_after_save = {
                lsp_fallback = true,
            },

            formatters = {
                goimports_reviser = {
                    command = "goimports-reviser",
                    args = { "-output", "stdout", "$FILENAME" },
                },
            },
        })

        -- Override stylua's default indent type
        table.insert(require("conform.formatters.stylua").args, "--indent-type")
        table.insert(require("conform.formatters.stylua").args, "Spaces")

        -- Override prettier's default indent type
        table.insert(require("conform.formatters.prettier").args, "--tab-width")
        table.insert(require("conform.formatters.prettier").args, "4")
    end,
}
