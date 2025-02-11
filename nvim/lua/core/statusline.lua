local M = {}

function _G._statusline_component(name, hl)
    return M[name](hl)
end

local function format_component(val, hl)
    hl = hl or "Comment"
    return " %#" .. hl .. "#" .. val .. "%* "
end

local function component(val, hl)
    if val == nil or val == "" then
        return ""
    end

    -- when the component provides it's own hl or we want to use the default
    if hl == nil then
        return "%{%v:lua._statusline_component('" .. val .. "')%}"
    end
    return "%{%v:lua._statusline_component('" .. val .. "', '" .. hl .. "')%}"
end

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

-- Components
M.mode = function()
    local mode = vim.api.nvim_get_mode().mode
    local val = mode_map[mode]
    local hl = mode_hl_map[val]
    return format_component(" " .. string.lower(val), hl)
end

M.git_branch = function(hl)
    local branch = vim.g.gitsigns_head
    if not branch then
        return ""
    end
    return format_component(" " .. branch, hl)
end

M.git_diff = function(hl)
    local summary = vim.b.gitsigns_status
    if not summary then
        return ""
    end
    return format_component(summary, hl)
end

M.diagnostics = function()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    local components = {
        errors > 0 and format_component(" " .. errors, "DiagnosticError") or "",
        warnings > 0 and format_component(" " .. warnings, "DiagnosticWarn") or "",
        hints > 0 and format_component(" " .. hints, "DiagnosticHint") or "",
        info > 0 and format_component("󰝶 " .. info, "DiagnosticInfo") or "",
    }

    if errors + warnings + hints + info == 0 then
        return ""
    end

    return table.concat(components, "")
end

M.navic = function(hl)
    if package.loaded["nvim-navic"] and require("nvim-navic").is_available() then
        return format_component(require("nvim-navic").get_location(), hl)
    end
    return ""
end

M.status_messages = function()
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
        return format_component(mode)
    end
    --- @diagnostic enable: undefined-field
    return ""
end

M.lazy_updates = function(hl)
    local lazy_status = require("lazy.status")
    if lazy_status.has_updates() then
        return format_component(lazy_status.updates(), hl)
    end
    return ""
end

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

M.progress = function(hl)
    return format_component("%2p%%", hl)
end

M.location = function(hl)
    return format_component("%l:%c", hl)
end

M.clock = function(hl)
    --- @diagnostic disable-next-line: param-type-mismatch
    return format_component(os.date("%I:%M %p"):gsub("^0", ""), hl)
end

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
    component("progress", "Special"),
    component("location", "Changed"),
    component("clock", "Conceal"),
}

M.statusline = table.concat(components, "")

return M
