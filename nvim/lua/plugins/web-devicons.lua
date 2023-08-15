-- Nvim-web-devicons https://github.com/nvim-tree/nvim-web-devicons
local M = {
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        color_icons = true,
        override = {
          yaml = {
            icon = "",
            color = "#f38ba8",
            name = "Yaml"
          },
          go = {
            icon = "󰟓",
            color = "#79d4fd",
            name = "Go"
          },
        },
        override_by_extension = {
          ["bicep"] = {
            icon = "",
            color = "#74c7ec",
            name = "Bicep"
          },
          ["bicepparam"] = {
            icon = "",
            color = "#cba6f7",
            name = "BicepParameters"
          },
        }
      })
    end,
  }
}

return M
