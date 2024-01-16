return {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    config = function()
        vim.g.disable_autoformat = false
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
                bicep = { "trim_whitespace", "trim_newlines" },
                css = { "prettier" },
                go = { "goimports_reviser", "gofmt", "golines" },
                html = { "prettier" },
                javascript = { "prettier" },
                json = { "prettier" },
                lua = { "stylua" },
                markdown = { "markdownlint-cli2" },
                ps1 = { "powershell", "trim_whitespace", "trim_newlines" },
                scss = { "prettier" },
                toml = { "taplo" },
                yaml = { "prettier" },
            },

            format_after_save = function(buf)
                if vim.g.disable_autoformat then
                    return
                end
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
                        "(Invoke-Formatter",
                        "(Get-Content -Raw -Path",
                        "$FILENAME",
                        ")).Trim()",
                    },
                },
            },
        })

        -- Override stylua's default indent type
        require("conform").formatters.stylua = {
            prepend_args = { "--indent-type", "Spaces" },
        }

        -- Override prettier's default indent type
        require("conform").formatters.prettier = {
            prepend_args = { "--tab-width", "4" },
        }

        -- Toggle format on save
        vim.api.nvim_create_user_command("ConformToggle", function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            print("Conform " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
        end, {
            desc = "Toggle format on save",
        })
    end,
}
