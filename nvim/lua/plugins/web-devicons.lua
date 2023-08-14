-- Nvim-web-devicons https://github.com/nvim-tree/nvim-web-devicons
local M = {
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        color_icons = true,
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
