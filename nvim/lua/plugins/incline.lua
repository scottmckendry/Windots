return {
    "b0o/incline.nvim",
    event = "BufEnter",
    config = function()
        local icons = require("mini.icons")
        local utils = require("core.utils")
        require("incline").setup({
            window = {
                padding = 0,
                margin = { horizontal = 0 },
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                if filename == "" then
                    filename = "[No Name]"
                end

                local icon, hl_group = icons.get("file", filename)
                local fg = "#16181a"
                local bg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = hl_group }).fg)
                local annotation = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "NonText" }).fg)
                local modified = vim.bo[props.buf].modified
                local other_bufs = utils.get_buffer_count() - 1

                return {
                    icon and { "  ", icon, " ", guifg = fg, guibg = bg } or "  ",
                    { filename, gui = modified and "bold,italic" or "bold", guifg = fg, guibg = bg },
                    " ",
                    guibg = bg,
                    other_bufs >= 1 and { "+", other_bufs, " ", guifg = annotation, gui = "italic" } or "",
                    " ",
                }
            end,
        })
    end,
}
