local terminal = os.getenv("TERM")
if terminal == "xterm-kitty" then
    return {}
end

return {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
        legacy_computing_symbols_support = true,
    },
}
