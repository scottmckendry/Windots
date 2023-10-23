return {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    config = function()
        local lsp_fallback = setmetatable({
            bicep = "always",
        }, {
            -- default true
            __index = function()
                return true
            end,
        })
        require("conform").setup({
            formatters_by_ft = {
                go = { "goimports_reviser", "gofmt", "golines" },
                lua = { "stylua" },
                html = { "prettier" },
                javascript = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                ps1 = { "powershell", "trim_whitespace", "trim_newlines" },
                bicep = { "trim_whitespace", "trim_newlines" },
            },

            format_after_save = function(buf)
                return {
                    lsp_fallback = lsp_fallback[vim.bo[buf].filetype],
                }
            end,

            formatters = {
                goimports_reviser = {
                    command = "goimports-reviser",
                    args = { "-output", "stdout", "$FILENAME" },
                },
                powershell = {
                    command = "pwsh",
                    args = {
                        "-NoLogo",
                        "-NoProfile",
                        "-NonInteractive",
                        "-Command",
                        "Invoke-Formatter",
                        "( Get-Content -Raw -Path",
                        "$FILENAME",
                        ")",
                    },
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
