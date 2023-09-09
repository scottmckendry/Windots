vim.g.mapleader = " "

local keymap = vim.keymap

-- Windows
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
