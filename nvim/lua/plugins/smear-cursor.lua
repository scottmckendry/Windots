local terminal = os.getenv("TERM")
if terminal == "xterm-kitty" then
    return {}
end

return {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
        stiffness = 0.8,
        trailing_stiffness = 0.6,
        trailing_exponent = 0,
        distance_stop_animating = 0.5,
        hide_target_hack = false,
        legacy_computing_symbols_support = true,
    },
}
