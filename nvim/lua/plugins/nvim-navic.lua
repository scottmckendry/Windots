return {
    "smiteshp/nvim-navic",
    config = function()
        require("nvim-navic").setup({
            lsp = {
                auto_attach = true,
            },
            separator = " 󰁔 ",
        })
    end,
}
