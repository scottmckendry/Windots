return {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        symbol = "│",
        options = { try_as_border = true },
    },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "help",
                "alpha",
                "Trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "neotree",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
}
