local M = {}

--- Get highlight properties for a given highlight name
---@param name string The highlight group name
---@param fallback? table The fallback highlight properties
---@return table properties # the highlight group properties
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

--- Parse a given integer color to a hex value.
function M.parse_hex(int_color)
    return string.format("#%x", int_color)
end

return M
