return {
	"stevearc/conform.nvim",
	event = "BufReadPre",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				go = { "goimports_reviser", "gofmt", "golines" },
				lua = { "stylua" },
				html = { "prettier" },
				javascript = { "prettier" },
				css = { "prettier" },
			},

			format_after_save = {
				lsp_fallback = true,
			},

			formatters = {
				goimports_reviser = {
					command = "goimports-reviser",
					args = { "-output", "stdout", "$FILENAME" },
				},
			},
		})
	end,
}
