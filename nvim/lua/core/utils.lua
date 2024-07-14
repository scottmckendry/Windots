local M = {}

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
    if vim.fn.hlexists(name) == 1 then
        local group = vim.api.nvim_get_hl(0, { name = name })

        local hl = {
            fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
            bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
        }

        return hl
    end
    return fallback or {}
end

--- Remove a buffer by its number without affecting window layout
--- @param buf? number The buffer number to delete
function M.delete_buffer(buf)
    if buf == nil or buf == 0 then
        buf = vim.api.nvim_get_current_buf()
    end

    vim.api.nvim_command("bwipeout " .. buf)
end

--- Switch to the previous buffer
function M.switch_to_previous_buffer()
    local ok, _ = pcall(function()
        vim.cmd("buffer #")
    end)
    if not ok then
        vim.notify("No other buffer to switch to!", 3, { title = "Warning" })
    end
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.bufname(buf) ~= "" then
            count = count + 1
        end
    end
    return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
    return string.format("#%x", int_color)
end

--- Create a centered floating window of a given width and height, relative to the size of the screen.
--- @param width number width of the window where 1 is 100% of the screen
--- @param height number height of the window - between 0 and 1
--- @param buf number The buffer number
--- @return number The window number
function M.open_centered_float(width, height, buf)
    buf = buf or vim.api.nvim_create_buf(false, true)
    local win_width = math.floor(vim.o.columns * width)
    local win_height = math.floor(vim.o.lines * height)
    local offset_y = math.floor((vim.o.lines - win_height) / 2)
    local offset_x = math.floor((vim.o.columns - win_width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = offset_y,
        col = offset_x,
        style = "minimal",
        border = "single",
    })

    return win
end

--- Open the help window in a floating window
--- @param buf number The buffer number
function M.open_help(buf)
    if buf ~= nil and vim.bo[buf].filetype == "help" then
        local help_win = vim.api.nvim_get_current_win()
        local new_win = M.open_centered_float(0.6, 0.7, buf)

        -- set keymap 'q' to close the help window
        vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q!<CR>", {
            nowait = true,
            noremap = true,
            silent = true,
        })

        -- set scroll position
        vim.wo[help_win].scroll = vim.wo[new_win].scroll

        -- close the help window
        vim.api.nvim_win_close(help_win, true)
    end
end

return M
