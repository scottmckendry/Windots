return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                auto_trigger = true,
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                yaml = true,
                help = true,
            },
        })
    end,
}
