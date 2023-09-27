local M = {}

--- Get highlight properties for a given highlight name
---@param name string The highlight group name
---@param fallback? table The fallback highlight properties
---@return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
    if vim.fn.hlexists(name) == 1 then
        local hl
        hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        if not hl.fg then hl.fg = "NONE" end
        if not hl.bg then hl.bg = "NONE" end
        return hl
    end
    return fallback or {}
end

return M
