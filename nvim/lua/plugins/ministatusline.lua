return {
    "echasnovski/mini.statusline",
    lazy = false,
    dependencies = { "smiteshp/nvim-navic" },
    config = function()
        local statusline = require("mini.statusline")

        -- utility functions
        local function hl_component(sign, highlight)
            return "%#" .. highlight .. "#" .. sign
        end

        -- constants
        local signs = {
            ERROR = hl_component(" ", "DiagnosticError"),
            WARN = hl_component(" ", "DiagnosticWarn"),
            INFO = hl_component(" ", "DiagnosticInfo"),
            HINT = hl_component("󰝶 ", "DiagnosticHint"),
        }

        local copilot_highlights = {
            [""] = "Comment",
            ["Normal"] = "Comment",
            ["Warning"] = "DiagnosticError",
            ["InProgress"] = "DiagnosticWarn",
        }

        -- components
        local function git_diff()
            local summary = vim.b.gitsigns_status
            if not summary then
                return ""
            end
            return summary
        end

        local function navic_location()
            if package.loaded["nvim-navic"] and require("nvim-navic").is_available() then
                return require("nvim-navic").get_location()
            end
            return ""
        end

        local function copilot_status()
            local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
            if not (ok and #clients > 0) then
                return
            end

            local status = require("copilot.api").status.data
            return hl_component(" ", copilot_highlights[status.status])
        end

        local function progress()
            local cur_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")

            if cur_line == 1 then
                return "Top"
            end
            if cur_line == total_lines then
                return "Bot"
            end

            return string.format("%2d%%%%", math.floor(cur_line / total_lines * 100))
        end

        local function location()
            return string.format("%3d:%-2d", vim.fn.line("."), vim.fn.charcol("."))
        end

        local function clock()
            --- @diagnostic disable-next-line: param-type-mismatch
            return os.date("%I:%M %p"):gsub("^0", "")
        end

        -- build statusline
        local function get_statusline_content()
            local mode, mode_hl = statusline.section_mode({})
            local git = statusline.section_git({})
            local diagnostics = statusline.section_diagnostics({ signs = signs, icon = "" })
            local search_count = statusline.section_searchcount({})

            return statusline.combine_groups({
                { hl = mode_hl, strings = { " " .. string.lower(mode) } },
                { hl = "Changed", strings = { git } },
                { hl = "Type", strings = { git_diff() } },
                { hl = "Normal", strings = { diagnostics } },
                "%<", -- Mark general truncate point
                { hl = "Comment", strings = { navic_location() } },
                "%=", -- End left alignment
                { hl = "Normal", strings = { copilot_status() } },
                { hl = "Changed", strings = { search_count } },
                { hl = "String", strings = { progress() } },
                { hl = "Type", strings = { location() } },
                { hl = "Comment", strings = { clock() } },
            })
        end

        -- Setup
        statusline.setup({
            content = {
                active = get_statusline_content,
            },
            set_vim_settings = false,
        })
    end,
}
