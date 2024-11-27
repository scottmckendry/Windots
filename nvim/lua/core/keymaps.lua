local utils = require("core.utils")
local snacks = require("snacks")

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

local copilot_toggle_opts = {
    name = "Copilot Completion",
    get = function()
        return not require("copilot.client").is_disabled()
    end,
    set = function(state)
        if state then
            require("copilot.command").enable()
        else
            require("copilot.command").disable()
        end
    end,
}

-- stylua: ignore start

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers
map("n", "<leader>bb", function() utils.switch_to_other_buffer() end, { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() snacks.bufdelete({ wipe = true }) end, { desc = "Delete buffer" })
map("n", "L", ":bnext<cr>", { desc = "Next buffer" })
map("n", "H", ":bprevious<cr>", { desc = "Previous buffer" })

-- lazy
map("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<cr>", { desc = "Fuzzy find files" })
map("n", "<leader>fr", ":Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
map("n", "<leader>fs", ":Telescope live_grep<cr>", { desc = "Find string in CWD" })
map("n", "<leader>fc", ":Telescope grep_string<cr>", { desc = "Find string under cursor in CWD" })
map("n", "<leader>fb", ":Telescope buffers<cr>", { desc = "Fuzzy find buffers" })
map("n", "<leader>ft", ":Telescope<cr>", { desc = "Other pickers..." })
map("n", "<leader>fS", ":Telescope resession<cr>", { desc = "Find Session" })
map("n", "<leader>fh", ":Telescope help_tags<cr>", { desc = "Find help tags" })
map("n", "<leader>df", function() utils.telescope_diff_file() end, { desc = "Diff file with current buffer" })
map("n", "<leader>dr", function() utils.telescope_diff_file(true) end, { desc = "Diff recent file with current buffer" })
map("n", "<leader>dg", function() utils.telescope_diff_from_history() end, { desc = "Diff from git history" })

-- toggle options
utils.toggle_global_boolean("autoformat", "Autoformat"):map("<leader>ta")
snacks.toggle(copilot_toggle_opts):map("<leader>tc")
snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
snacks.toggle.diagnostics():map("<leader>td")
snacks.toggle.line_number():map("<leader>tl")
snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tC")
snacks.toggle.treesitter():map("<leader>tT")
if vim.lsp.inlay_hint then snacks.toggle.inlay_hints():map("<leader>th") end

-- browse to git repo
map("n", "<leader>gb", function() snacks.gitbrowse() end, { desc = "Git Browse" })

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
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", ":LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gr", ":Telescope lsp_references<cr>", { desc = "Goto References" })
map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, { desc = "Goto Definition" })
map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, { desc = "Goto Type Definition" })

-- Terminal/Run...
map({"n", "t"}, "<C-\\>", function() snacks.terminal() end, { desc = "Toggle Terminal" })
map("n", "<leader>gg", function() snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>rlf", ":luafile %<cr>", { desc = "Run Current Lua File" })
map("n", "<leader>rlt", ":PlenaryBustedFile %<cr>", { desc = "Run Lua Test File" })
map("n", "<leader>rss", function() snacks.terminal.toggle(vim.fn.expand("%:p"), { interactive = false }) end, { desc = "Run shell script (bash, powershell, etc)" })
map("n", "<leader>rm", function() snacks.terminal.toggle("make", { interactive = false }) end, { desc = "Run make" })
map("n", "<leader>rt", function() snacks.terminal.toggle("task", { interactive = false }) end, { desc = "Run task" })
-- stylua: ignore end
