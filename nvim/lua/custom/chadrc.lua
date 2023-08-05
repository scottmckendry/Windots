---@type ChadrcConfig 
local M = {}

M.ui = {
  theme = "tokyonight",
  nvdash = {
    load_on_startup = true,
    header = {
      [[███╗   ██╗██╗   ██╗██╗███╗   ███╗]],
      [[████╗  ██║██║   ██║██║████╗ ████║]],
      [[██╔██╗ ██║██║   ██║██║██╔████╔██║]],
      [[██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    },
  },
  statusline = {
    separator_style = "round",
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.options = require "custom.options"
return M
