local utils = require("core.utils")

--- Map a key combination to a command
---@param modes string|string[]: The mode(s) to map the key combination to
---@param lhs string: The key combination to map
---@param rhs string|function: The command to run when the key combination is pressed
---@param opts table: Options to pass to the keymap
local map = function(modes, lhs, rhs, opts)
    local options = { silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(modes) == "string" then
        modes = { modes }
    end
    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, lhs, rhs, options)
    end
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", ":resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Buffers
-- stylua: ignore start
map("n", "<leader>bb", function() utils.switch_to_other_buffer() end, { desc = "Switch to other buffer" })
map("n", "<leader>bd", function() utils.delete_buffer() end, { desc = "Delete buffer" })
map("n", "L", ":bnext<cr>", { desc = "Next buffer" })
map("n", "H", ":bprevious<cr>", { desc = "Previous buffer" })
-- stylua: ignore end

-- lazy
map("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })

-- AI
map("n", "<leader>at", ":Copilot toggle<cr>", { desc = "Toggle (Copilot Inline)" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<cr>", { desc = "Fuzzy find files" })
map("n", "<leader>fr", ":Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
map("n", "<leader>fs", ":Telescope live_grep<cr>", { desc = "Find string in CWD" })
map("n", "<leader>fc", ":Telescope grep_string<cr>", { desc = "Find string under cursor in CWD" })
map("n", "<leader>fb", ":Telescope buffers<cr>", { desc = "Fuzzy find buffers" })
map("n", "<leader>ft", ":Telescope<cr>", { desc = "Other pickers..." })
map("n", "<leader>fS", ":Telescope resession<cr>", { desc = "Find Session" })
map("n", "<leader><leader>", ":Telescope smart_open<cr>", { desc = "Smart open" })
map("n", "<leader>fh", ":Telescope help_tags<cr>", { desc = "Find help tags" })
-- stylua: ignore start
map("n", "<leader>df", function() utils.telescope_diff_file() end, { desc = "Diff file with current buffer" })
map("n", "<leader>dr", function() utils.telescope_diff_file(true) end, { desc = "Diff recent file with current buffer" })
map("n", "<leader>dg", function() utils.telescope_diff_from_history() end, { desc = "Diff from git history" })
-- stylua: ignore end

-- Clear search with <esc>
map("n", "<esc>", ":noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- quit
map("n", "<leader>qq", ":qa<cr>", { desc = "Quit all" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab><tab>", ":tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>l", ":tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", ":tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>h", ":tabprevious<cr>", { desc = "Previous Tab" })

-- Code/LSP
-- stylua: ignore start
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", ":LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gr", ":Telescope lsp_references<cr>", { desc = "Goto References" })
map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, { desc = "Goto Definition" })
map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, { desc = "Goto Type Definition" })
-- stylua: ignore end

-- Lazygit
map("n", "<leader>gg", function()
    local term = require("toggleterm.terminal").Terminal
    local lazygit = term:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "tab",
    })
    lazygit:toggle()
end, { desc = "Lazygit" })

-- Run...
-- stylua: ignore start
map("n", "<leader>rlf", ":luafile %<cr>", { desc = "Run Current Lua File" })
map("n", "<leader>rlt", ":PlenaryBustedFile %<cr>", { desc = "Run Lua Test File" })
map("n", "<leader>rss", function() utils.run_shell_script() end, { desc = "Run shell script (bash, powershell, etc)" })
-- stylua: ignore end
