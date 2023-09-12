return {
	"nvimdev/guard.nvim",
	event = "BufReadPre",
	config = function()
		local ft = require("guard.filetype")
		ft("go")
		    :fmt({
			    cmd = "goimports-reviser",
			    args = { "-output", "stdout" },
			    fname = true,
		    })
		    :append({
			    cmd = "gofmt",
			    stdin = true,
		    })
		    :append({
			    cmd = "golines",
			    stdin = true,
		    })

		ft("lua"):fmt("lsp")

		require("guard").setup({
			-- the only options for the setup function
			fmt_on_save = true,
			-- Use lsp if no formatter was defined for this filetype
			lsp_as_default_formatter = false,
		})
	end,
}
