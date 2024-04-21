-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font_with_fallback({
    {
        family = "JetBrainsMono Nerd Font",
        weight = "DemiBold",
    },
    "Segoe UI Emoji",
})
config.font_size = 10

-- Window
config.initial_rows = 45
config.initial_cols = 180
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.win32_system_backdrop = "Acrylic"
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

-- Colors
config.colors = require("cyberdream")
config.force_reverse_video_cursor = true

-- Shell
config.default_prog = { "pwsh", "-NoLogo" }

-- Keybindings
config.keys = {
    -- Remap paste for clipboard history compatibility
    { key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

return config
