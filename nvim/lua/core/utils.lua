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
    local win_id = vim.fn.bufwinid(buf)
    local alt_buf = vim.fn.bufnr("#")
    if alt_buf ~= buf and vim.fn.buflisted(buf) == 1 and alt_buf ~= -1 then
        vim.api.nvim_win_set_buf(win_id, alt_buf)
        vim.api.nvim_command("bwipeout " .. buf)
        return
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local has_prev_buf = pcall(vim.cmd, "bprevious")
    if has_prev_buf and buf ~= vim.api.nvim_win_get_buf(win_id) then
        vim.api.nvim_command("bwipeout " .. buf)
        return
    end

    -- if alternate and previous buffers are both unavailable, create a new buffer instead
    local new_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win_id, new_buf)
    vim.api.nvim_command("bwipeout " .. buf)
end

--- Switch to the previous buffer
function M.switch_to_other_buffer()
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

        -- set scroll position
        vim.wo[help_win].scroll = vim.wo[new_win].scroll

        -- close the help window
        vim.api.nvim_win_close(help_win, true)
    end
end

--- Run a shell command and return the output
--- @param cmd table The command to run in the format { "command", "arg1", "arg2", ... }
--- @param cwd? string The current working directory
--- @return table stdout, number? return_code, table? stderr
function M.get_cmd_output(cmd, cwd)
    if type(cmd) ~= "table" then
        vim.notify("Command must be a table", 3, { title = "Error" })
        return {}
    end

    local command = table.remove(cmd, 1)
    local stderr = {}
    local stdout, ret = require("plenary.job")
        :new({
            command = command,
            args = cmd,
            cwd = cwd,
            on_stderr = function(_, data)
                table.insert(stderr, data)
            end,
        })
        :sync()

    return stdout, ret, stderr
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

--- Display a diff between the current buffer and a given file
--- @param file string The file to diff against the current buffer
function M.diff_file(file)
    local pos = vim.fn.getpos(".")
    local current_file = vim.fn.expand("%:p")
    vim.cmd("edit " .. file)
    vim.cmd("vert diffsplit " .. current_file)
    vim.fn.setpos(".", pos)
end

--- Display a diff between a file at a given commit and the current buffer
--- @param commit string The commit hash
--- @param file_path string The file path
function M.diff_file_from_history(commit, file_path)
    local extension = vim.fn.fnamemodify(file_path, ":e") == "" and "" or "." .. vim.fn.fnamemodify(file_path, ":e")
    local temp_file_path = os.tmpname() .. extension

    local cmd = { "git", "show", commit .. ":" .. file_path }
    local out = M.get_cmd_output(cmd)

    M.write_to_file(temp_file_path, out)
    M.diff_file(temp_file_path)
end

--- Open a telescope picker to select a file to diff against the current buffer
--- @param recent? boolean If true, open the recent files picker
function M.telescope_diff_file(recent)
    local picker = require("telescope.builtin").find_files
    if recent then
        picker = require("telescope.builtin").oldfiles
    end

    picker({
        prompt_title = "Select File to Compare",
        attach_mappings = function(prompt_bufnr)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                M.diff_file(selection.value)
            end)
            return true
        end,
    })
end

--- Open a telescope picker to select a commit to diff against the current buffer
function M.telescope_diff_from_history()
    local current_file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:."):gsub("\\", "/")
    require("telescope.builtin").git_commits({
        git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "--follow", "--", current_file },
        attach_mappings = function(prompt_bufnr)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                M.diff_file_from_history(selection.value, current_file)
            end)
            return true
        end,
    })
end

--- Run current file inside toggleterm
function M.run_shell_script()
    local script = vim.fn.expand("%:p")
    require("toggleterm").exec(script)
end

return M
