return {
    "b0o/incline.nvim",
    event = "VeryLazy",
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
                local modified = vim.bo[props.buf].modified
                return {
                    icon and { "  ", icon, " ", group = hl_group, guibg = "#3c4048" } or "  ",
                    { filename, gui = modified and "bold,italic" or "bold" },
                    " ",
                    guibg = "#3c4048",
                    { "+", utils.get_buffer_count(), " ", group = "Comment" },
                    " ",
                }
            end,
        })
    end,
}
