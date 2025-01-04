local M = {}

--- Get the current operating system
-- @return "windows"| "linux" | "macos"
M.get_os = function()
    local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
    if bin_format == "dll" then
        return "windows"
    elseif bin_format == "so" then
        return "linux"
    elseif bin_format == "dylib" then
        return "macos"
    end
end

return M
