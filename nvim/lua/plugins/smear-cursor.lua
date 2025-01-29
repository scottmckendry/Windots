local terminal = os.getenv("TERM")
if terminal == "xterm-kitty" then
    return {}
end

return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
        legacy_computing_symbols_support = true,
        min_horizontal_distance_smear = 3,
        min_vertical_distance_smear = 3,
        filetypes_disabled = {
            "snacks_terminal",
            "lazy",
        },
    },
}
