return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    keys = {
        {
            "<leader>aa",
            function()
                return require("CopilotChat").toggle()
            end,
            desc = "Toggle",
            mode = { "n", "v" },
        },
        {
            "<leader>ax",
            function()
                return require("CopilotChat").reset()
            end,
            desc = "Clear",
            mode = { "n", "v" },
        },
        {
            "<leader>aq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input)
                end
            end,
            desc = "Quick Chat",
            mode = { "n", "v" },
        },
        {
            "<leader>ac",
            ":CopilotChatCommit<cr>",
            desc = "Commit",
            mode = { "n", "v" },
        },
    },
    config = function()
        -- TODO: add blink.cmp integration when/if it's available
        -- require("CopilotChat.integrations.cmp").setup()
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "copilot-chat",
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false
            end,
        })

        require("CopilotChat").setup({
            model = "claude-3.5-sonnet",
            auto_insert_mode = true,
            show_help = false,
            show_folds = false,
            question_header = "  Scott ",
            answer_header = "  Copilot ",
            window = {
                layout = "float",
                width = 0.6,
                height = 0.7,
                border = "rounded",
            },
            mappings = {
                close = {
                    insert = "C-q",
                },
            },
            selection = function(source)
                local select = require("CopilotChat.select")
                return select.visual(source) or select.buffer(source)
            end,
        })
    end,
}
