return {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
        require("nvim-highlight-colors").setup({
            render = "virtual",
            virtual_symbol = "󰻂",
        })
    end,
}
