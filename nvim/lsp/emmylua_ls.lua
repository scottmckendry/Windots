--- @type vim.lsp.Config
return {
    cmd = { "emmylua_ls" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { disable = { "missing-fields" } },
            workspace = {
                checkThirdParty = false,
                library = (function()
                    local library = vim.api.nvim_get_runtime_file("", true)
                    local lazy_path = vim.fn.stdpath("data") .. "/lazy"

                    if vim.fn.isdirectory(lazy_path) == 1 then
                        local plugins = vim.fn.readdir(lazy_path)
                        for _, plugin in ipairs(plugins) do
                            table.insert(library, lazy_path .. "/" .. plugin)
                        end
                    end

                    return library
                end)(),
            },
        },
    },
}
