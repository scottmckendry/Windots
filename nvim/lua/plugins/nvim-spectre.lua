return {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
        {
            "<leader>sr",
            function()
                require("spectre").open()
            end,
            desc = "Replace in files (Spectre)",
        },
    },
}
