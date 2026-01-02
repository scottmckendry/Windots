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
---@param cmd table<string> The command to run in the terminal
--- @param fullscreen? boolean Open ther terminal in a fullscreen float
function M.open_terminal_toggle(cmd, fullscreen)
    local snacks = require("snacks")
    local opts = fullscreen and { win = { position = "float", width = 0.99, height = 0.99 } } or nil
    snacks.terminal.toggle(cmd, opts)
    if vim.bo.filetype == "snacks_terminal" then
        vim.notify("_Double press `ESC`_ to return to normal mode", 2, { title = cmd[1] })
    end
end

--- Restart all LSP clients attached to the current buffer
function M.restart_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP client attached to current buffer", vim.log.levels.WARN)
        return
    end
    for _, client in ipairs(clients) do
        local config = client.config
        local name = client.name
        client.stop(true)
        vim.defer_fn(function()
            vim.lsp.start(config)
            vim.notify("LSP restarted: " .. name, vim.log.levels.INFO)
        end, 50)
    end
end

--- Open the LSP log file in a readonly split
function M.open_lsp_log()
    local log_path = vim.lsp.get_log_path()
    if vim.fn.filereadable(log_path) == 0 then
        vim.notify("LSP log file not found: " .. log_path, vim.log.levels.WARN)
        return
    end
    vim.cmd("e " .. log_path)
    vim.notify("Opened LSP log: " .. log_path, vim.log.levels.INFO)
end

--- Open GitHub markdown preview for the current buffer
function M.gh_markdown_preview()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    vim.fn.jobstart({ "gh", "markdown-preview", bufname }, {
        on_stderr = function(_, data)
            if not data then
                return
            end
            --- remove the last line if it's empty
            if data[#data] == "" then
                table.remove(data, #data)
            end
            vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "Markdown Preview" })
        end,
    })
end

--- Find project root directory by searching for marker files/directories
--- @param buf integer Buffer number
--- @param names table|function Array of file names to search for, or a callable
--- @return string|nil root the root directory path, or nil if not found
function M.find_root(buf, names)
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" then
        return nil
    end

    local dir = vim.fn.fnamemodify(path, ":p:h")
    if dir == "" then
        return nil
    end

    -- Search upwards for marker files/directories
    local root = vim.fs.root(dir, names)
    return root or nil
end

return M
