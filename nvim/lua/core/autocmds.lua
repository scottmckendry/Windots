local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("core.utils")

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
    pattern = { "*.md", "*.txt" },
    callback = function()
        vim.opt_local.spell = true
    end,
    group = general,
    desc = "Enable spell checking on specific filetypes",
})

autocmd("BufWinEnter", {
    callback = function(data)
        utils.open_help(data.buf)
    end,
    group = general,
    desc = "Redirect help to floating window",
})

autocmd("FileType", {
    group = general,
    pattern = {
        "grug-far",
        "help",
        "checkhealth",
        "copilot-chat",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
        })
    end,
})

autocmd("BufEnter", {
    group = general,
    callback = function(event)
        local two_space_indent_types = {
            "nix",
        }
        if vim.tbl_contains(two_space_indent_types, vim.bo[event.buf].filetype) then
            vim.bo[event.buf].shiftwidth = 2
            vim.bo[event.buf].tabstop = 2
            vim.bo[event.buf].softtabstop = 2
        end
    end,
})
