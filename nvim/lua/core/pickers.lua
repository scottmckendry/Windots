-- WIP: don't use!
-- Currently not linked to any keybindings or commands - execute with `:luafile %` or 'rlf' keybinding with this file open

local picker = require("snacks").picker

local icons = {
    { match = "/home/scott/git/", icon = " ", highlight = "Changed" },
    { match = "/home/scott/", icon = " ", highlight = "Special" },
}

local fallback_icon = { icon = " ", highlight = "Directory" }

local function apply_icon(display_value)
    for _, icon in ipairs(icons) do
        if display_value:find(icon.match) then
            return icon, display_value:gsub(icon.match, "")
        end
    end
    return fallback_icon, display_value
end

local function format_session_item(item)
    local icon, display_value = apply_icon(item.display_value)
    return {
        { icon.icon, icon.highlight },
        { display_value, "Normal" },
    }
end

local function generate_sessions()
    local sessions = {}
    for idx, session in ipairs(require("resession").list()) do
        sessions[#sessions + 1] = {
            text = session,
            value = session,
            idx = idx,
            display_value = session:gsub("_", "/"),
        }
    end
    return sessions
end

picker.pick({
    title = "Sessions",
    finder = generate_sessions,
    layout = "vscode",
    format = format_session_item,
    confirm = function(self, item)
        self:close()
        require("resession").load(item.text)
    end,
    actions = {
        delete_session = function(self, item)
            require("resession").delete(item.text, { notify = false })
            self:find({
                refresh = true,
            })
        end,
    },
    win = {
        input = {
            keys = {
                ["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete session" },
            },
        },
    },
})
