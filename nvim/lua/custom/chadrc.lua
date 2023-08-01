---@type ChadrcConfig 
local M = {}
M.ui = {
  theme = "tokyonight",
  nvdash = {
    load_on_startup = true,
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.options = require "custom.options"
return M
