local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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
map("n", "<S-h>", ":BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "[b", ":BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "]b", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", ":e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", ":e #<cr>", { desc = "Switch to Other Buffer" })

-- lazy
map("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })

--keywordprg
map("n", "<leader>K", ":norm! K<cr>", { desc = "Keywordprg" })

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
map("n", "<leader><tab>l", ":tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", ":tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", ":tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", ":tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", ":tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", ":tabprevious<cr>", { desc = "Previous Tab" })

-- Code/LSP
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", ":LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
  { desc = "Goto Definition" })
map("n", "gr", ":Telescope lsp_references<cr>", { desc = "Goto References" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,
  { desc = "Goto Implementation" })
map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end,
  { desc = "Goto Type Definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
