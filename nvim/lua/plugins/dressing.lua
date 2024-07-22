return {
    "stevearc/dressing.nvim",
    event = "BufRead",
    opts = {
        input = {
            insert_only = false,
            start_in_insert = false,
            mappings = { i = { ["<C-c>"] = false } },
        },
    },
}
