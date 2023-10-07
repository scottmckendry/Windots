return {
    "smiteshp/nvim-navic",
    requires = { "neovim/nvim-lspconfig" },
    config = function()
        require("nvim-navic").setup({
            lsp = {
                auto_attach = true,
            },
            separator = " 󰁔 ",
        })
    end,
}
