return {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
        require("grug-far").setup({
            windowCreationCommand = "botright vsplit %",
        })
    end,
}
