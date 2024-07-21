return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<M-l>",
                    accept_line = "<M-L>",
                    accept_word = "<M-;>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                yaml = true,
                help = true,
                ["grug-far"] = false,
            },
        })
    end,
}
