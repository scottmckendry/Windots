return {
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
                yml = {
                    icon = "",
                    color = "#f38ba8",
                    name = "Yml"
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
                ["toml"] = {
                    icon = "󰗴",
                    color = "#db4b4b",
                    name = "Toml"
                }
            }
        })
    end,
}
