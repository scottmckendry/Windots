return {
	"nvim-lualine/lualine.nvim",
	event = "BufWinEnter",
	opts = function()
		return {
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = "󰝶 ",
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{
						"filename",
						path = 1,
						symbols = { modified = "  ", readonly = "", unnamed = "" }
					},
					-- stylua: ignore
					{
						function() return require("nvim-navic").get_location() end,
						cond = function()
							return package.loaded["nvim-navic"] and
							    require("nvim-navic").is_available()
						end,
					},
				},
				lualine_x = {
					{
						function() return require("noice").api.status.command.get() end,
						cond = function()
							return package.loaded["noice"] and
							    require("noice").api.status.command.has()
						end,
					},
					{
						function() return require("noice").api.status.mode.get() end,
						cond = function()
							return package.loaded["noice"] and
							    require("noice").api.status.mode.has()
						end,
					},
					{ require("lazy.status").updates, cond = require("lazy.status").has_updates },
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
					},
				},
				lualine_y = {
					{ "progress", separator = " ",                  padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%X")
					end,
				},
			},
			extensions = { "nvim-tree", "lazy" },
		}
	end,
}
