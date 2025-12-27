vim.filetype.add({ extension = { razor = "razor", cshtml = "razor" } })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.razor", "*.cshtml" },
    callback = function()
        vim.bo.filetype = "razor"
    end,
})
