local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove { "c", "r", "o" }
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

autocmd("BufEnter", {
	pattern = "*.bicepparam",
	callback = function()
		vim.bo.filetype = "bicep"
		vim.cmd("call timer_start(2000, { tid -> execute('w') })") -- Force write after 2 seconds to dismiss erroneous syntax errors
	end,
	group = general,
	desc = "Set bicepparam filetype to bicep",
})
