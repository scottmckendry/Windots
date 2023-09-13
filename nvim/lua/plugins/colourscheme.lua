return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			if vim.fn.has("unix") == 1 then
				require("tokyonight").setup({
					transparent = true,
					styles = {
						sidebars = "transparent",
						floats = "transparent",
					},
				})
			end
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
}
