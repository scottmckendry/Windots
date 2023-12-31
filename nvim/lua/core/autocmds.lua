local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
    group = general,
    desc = "Disable New Line Comment",
})

autocmd("BufEnter", {
    callback = function(opts)
        if vim.bo[opts.buf].filetype == "bicep" then
            vim.bo.commentstring = "// %s"
        end
    end,
    group = general,
    desc = "Set Bicep Comment String",
})

autocmd("BufWritePost", {
    pattern = "*.bicep*",
    callback = function()
        local winview = vim.fn.winsaveview()
        vim.cmd([[%s/\n\n}/\r}/ge]])
        vim.fn.winrestview(winview)
    end,
    group = general,
    desc = "Remove weird new lines added by LSP formatting",
})

autocmd("BufWritePost", {
    pattern = "*.ps1",
    callback = function()
        local winview = vim.fn.winsaveview()
        vim.cmd([[%s/\n\%$//ge]])
        vim.fn.winrestview(winview)
    end,
    group = general,
    desc = "Remove extra new lines at the end of formatted PowerShell files",
})
