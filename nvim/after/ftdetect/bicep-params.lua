vim.filetype.add({ extension = { bicep_params = "bicep-params" } })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.bicepparam",
    callback = function()
        vim.bo.filetype = "bicep-params"
    end,
})
