local M = {}

-- Mode mappings
local mode_map = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["i"] = "INSERT",
    ["c"] = "COMMAND",
    ["r"] = "REPLACE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
    ["nt"] = "TERMINAL",
}

local mode_hl_map = {
    ["NORMAL"] = "Directory",
    ["VISUAL"] = "Number",
    ["V-LINE"] = "Number",
    ["V-BLOCK"] = "Number",
    ["INSERT"] = "String",
    ["COMMAND"] = "Keyword",
    ["TERMINAL"] = "Keyword",
}

-- Helper functions
--- Global function for statusline component rendering. Can be called directly from the statusline
--- @param name string The name of the component to render
--- @param hl string The highlight group to use for the component
--- @return string
function _G._statusline_component(name, hl)
    return M[name](hl)
end

--- Format a given component value with a highlight group in the format expected by the statusline
--- @param val string The value to format
--- @param hl string|nil The highlight group to use
--- @param l_sep string|nil The left separator to use
--- @param r_sep string|nil The right separator to use
--- @return string
local function format_component(val, hl, l_sep, r_sep)
    l_sep = l_sep or " "
    r_sep = r_sep or " "
    hl = hl or "Comment"
    return l_sep .. "%#" .. hl .. "#" .. val .. "%*" .. r_sep
end

--- Generate a statusline component with optional highlight group
--- @param val string The value to render
--- @param hl string|nil The highlight group to use
--- @return string
local function component(val, hl)
    if val == nil or val == "" then
        return ""
    end

    if hl == nil then
        return "%{%v:lua._statusline_component('" .. val .. "')%}"
    end
    return "%{%v:lua._statusline_component('" .. val .. "', '" .. hl .. "')%}"
end

--- Get the count of diagnostics for a given severity
--- @param severity "ERROR"|"WARN"|"HINT"|"INFO"
--- @return number
local function get_diagnostic_count(severity)
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] })
end

--- Get the corresponding highlight group and statusline value for the current vim mode
--- @return string, string
local function get_mode_info()
    local mode = vim.api.nvim_get_mode().mode
    local val = mode_map[mode]
    return val, mode_hl_map[val]
end

-- Components
--- Mode component with dynamic highlights
--- @return string
M.mode = function()
    local val, hl = get_mode_info()
    if not val then
        return ""
    end
    return format_component(" " .. string.lower(val), hl)
end

--- Git branch component based on CWD - depends on gitsigns.nvim
--- @param hl string The highlight group to use
--- @return string
M.git_branch = function(hl)
    local branch = vim.g.gitsigns_head
    if not branch then
        return ""
    end
    return format_component(" " .. branch, hl)
end

--- Git diff component - current buffer, depends on gitsigns.nvim
--- @param hl string The highlight group to use
--- @return string
M.git_diff = function(hl)
    local summary = vim.b.gitsigns_status
    if not summary or summary == "" then
        return ""
    end

    summary = summary:gsub("+", " ")
    summary = summary:gsub("-", " ")
    summary = summary:gsub("~", " ")

    return format_component(summary, hl)
end

--- Buffer diagnostics component
--- @return string
M.diagnostics = function()
    local errors = get_diagnostic_count("ERROR")
    local warnings = get_diagnostic_count("WARN")
    local hints = get_diagnostic_count("HINT")
    local info = get_diagnostic_count("INFO")

    if errors + warnings + hints + info == 0 then
        return ""
    end

    local components = {
        errors > 0 and format_component(" " .. errors, "DiagnosticError", "") or "",
        warnings > 0 and format_component(" " .. warnings, "DiagnosticWarn", "") or "",
        hints > 0 and format_component(" " .. hints, "DiagnosticHint", "") or "",
        info > 0 and format_component("󰝶 " .. info, "DiagnosticInfo", "") or "",
    }

    return " " .. table.concat(components, "") .. " "
end

--- Buffer location component - dependes on nvim-navic
--- @param hl string The highlight group to use
M.navic = function(hl)
    if package.loaded["nvim-navic"] and require("nvim-navic").is_available() then
        return format_component(require("nvim-navic").get_location(), hl)
    end
    return ""
end

--- Status messages component. Shows @recording meesages. Depends on noice.nvim
--- @param hl string|nil The highlight group to use
--- @return string
M.status_messages = function(hl)
    local ignore = {
        "-- INSERT --",
        "-- TERMINAL --",
        "-- VISUAL --",
        "-- VISUAL LINE --",
        "-- VISUAL BLOCK --",
    }
    --- @diagnostic disable: undefined-field
    local mode = require("noice").api.status.mode.get()
    if require("noice").api.status.mode.has() and not vim.tbl_contains(ignore, mode) then
        return format_component(mode, hl)
    end
    --- @diagnostic enable: undefined-field
    return ""
end

--- Lazy updates component - show pending lazy.nvim updates
--- @param hl string The highlight group to use
M.lazy_updates = function(hl)
    local updates = require("lazy.status").updates()
    if type(updates) == "string" then
        return format_component(updates, hl)
    end
    return ""
end

--- Copilot status component - depends on copilot.lua
--- @return string
M.copilot_status = function()
    local copilot_highlights = {
        [""] = "Comment",
        ["Normal"] = "Comment",
        ["Warning"] = "DiagnosticError",
        ["InProgress"] = "DiagnosticWarn",
    }

    local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
    if not (ok and #clients > 0) then
        return ""
    end

    local status = require("copilot.api").status.data
    return format_component(" ", copilot_highlights[status.status])
end

--- Search count component - show current and total search matches when searching a buffer
--- @param hl string|nil The highlight group to use
--- @return string
M.search_count = function(hl)
    if vim.v.hlsearch == 0 then
        return ""
    end

    local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
    if not ok or s_count.current == nil or s_count.total == 0 then
        return ""
    end

    if s_count.incomplete == 1 then
        return format_component("?/?", hl)
    end

    return format_component(s_count.current .. "/" .. s_count.total, hl)
end

--- File name component - show the current buffer's file name and coloured icon. Depends on mini.icons.
--- @param hl string The highlight group to use
M.file_name = function(hl)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    if filename == "" then
        return ""
    end

    local icon, icon_hl = require("mini.icons").get("file", filename)
    if not icon then
        return ""
    end

    return format_component(icon, icon_hl, " ", "") .. format_component(filename, hl)
end

--- Buffer count component - show the number of other open buffers
--- @param hl string The highlight group to use
M.other_buffers = function(hl)
    local other_bufs = require("core.utils").get_buffer_count() - 1
    if other_bufs < 1 then
        return ""
    end
    return format_component("+" .. other_bufs .. " ", hl, "", " ")
end

--- Progress component - show percentage of buffer scrolled
--- @param hl string|nil The highlight group to use
M.progress = function(hl)
    return format_component("%2p%%", hl)
end

--- Clock component - show current time
--- @param hl string|nil The highlight group to use
M.location = function(hl)
    return format_component("%l:%c", hl)
end

--- Clock component - show current time
--- @param hl string|nil The highlight group to use
M.clock = function(hl)
    --- @diagnostic disable-next-line: param-type-mismatch
    return format_component(os.date("%I:%M %p"):gsub("^0", ""), hl)
end

-- Statusline components
local components = {
    component("mode"),
    component("git_branch", "Changed"),
    component("git_diff", "Type"),
    component("diagnostics"),
    "%<", -- mark general truncate point
    component("navic", "Comment"),
    "%=", -- mark end of left alignment
    component("status_messages"),
    component("lazy_updates", "String"),
    component("copilot_status"),
    component("search_count", "Directory"),
    component("file_name", "Normal"),
    component("other_buffers", "Comment"),
    component("progress", "Special"),
    component("location", "Changed"),
    component("clock", "Conceal"),
}

--- Return the statusline as a concatenated string - use with vim.opt.statusline to set
--- @type string
M.statusline = table.concat(components, "")

return M
