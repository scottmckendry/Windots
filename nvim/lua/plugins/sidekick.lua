return {
    "folke/sidekick.nvim",
    opts = {},
    event = "BufEnter",
    keys = {
        {
            "<Tab>",
            function()
                if require("sidekick").nes_jump_or_apply() then
                    return
                end
                return "<tab>"
            end,
            mode = { "i", "n" },
            expr = true,
            desc = "Goto/Apply Next Edit Suggestion",
        },
    },
}
