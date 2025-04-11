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

--- Switch to the previous buffer
function M.switch_to_other_buffer()
    -- try alternate buffer first
    local ok, _ = pcall(function()
        vim.cmd("buffer #")
    end)
    if ok then
        return
    end

    -- fallback to previous buffer
    if M.get_buffer_count() > 1 then
        vim.cmd("bprevious")
        return
    end

    vim.notify("No other buffer to switch to!", 3, { title = "Warning" })
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and vim.bo[buf].buftype ~= "nofile" then
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

--- Open the help window in a floating window
--- @param buf number The buffer number
function M.open_help(buf)
    if buf ~= nil and vim.bo[buf].filetype == "help" and not vim.bo[buf].modifiable then
        local help_win = vim.api.nvim_get_current_win()
        local new_win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            row = 0,
            col = vim.o.columns - 80,
            width = 80,
            height = vim.o.lines - 3,
            border = "rounded",
        })

        -- set scroll position
        vim.wo[help_win].scroll = vim.wo[new_win].scroll

        -- close the help window
        vim.api.nvim_win_close(help_win, true)
    end
end

--- Write a table of lines to a file
--- @param file string Path to the file
--- @param lines table Table of lines to write to the file
function M.write_to_file(file, lines)
    if not lines or #lines == 0 then
        return
    end
    local buf = io.open(file, "w")
    for _, line in ipairs(lines) do
        if buf ~= nil then
            buf:write(line .. "\n")
        end
    end

    if buf ~= nil then
        buf:close()
    end
end

function M.toggle_global_boolean(option, description)
    return require("snacks").toggle({
        name = description,
        get = function()
            return vim.g[option] == nil or vim.g[option]
        end,
        set = function(state)
            vim.g[option] = state
        end,
    })
end

--- Open K9s in a fullscreen interactive terminal
function M.k9s()
    local snacks = require("snacks")
    local cmd = { "k9s" }
    snacks.terminal.toggle(cmd, { win = { position = "float", width = 0.99, height = 0.99 } })
    if vim.bo.filetype == "snacks_terminal" then
        vim.notify("_Double press_ `ESC` then `<leader>kk` to toggle.", 2, { title = "K9s" })
    end
end

return M
