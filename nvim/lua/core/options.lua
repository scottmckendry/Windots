vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Set shell to PowerShell 7
opt.shell = "pwsh -NoLogo"
opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
opt.shellquote = ""
opt.shellxquote = ""

-- UI/General
opt.relativenumber = true
opt.ignorecase = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.termguicolors = true
opt.confirm = true
opt.mouse = "a"

-- Set tab width
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.expandtab = true

-- Make cursor blink
opt.guicursor = {
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}
