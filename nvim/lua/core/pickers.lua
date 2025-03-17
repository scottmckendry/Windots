-- WIP: don't use!
-- Currently not linked to any keybindings or commands - execute with `:luafile %` or 'rlf' keybinding with this file open

local picker = require("snacks").picker

local function generate_sessions()
    local sessions = {}
    for idx, session in ipairs(require("resession").list()) do
        sessions[#sessions + 1] = {
            text = session,
            value = session,
            idx = idx,
            display_value = idx .. ". " .. session,
        }
    end
    return sessions
end

picker.pick({
    title = "Sessions",
    finder = generate_sessions,
    layout = "vscode",
    format = function(item)
        local ret = {} ---@type snacks.picker.Highlight[]
        ret[#ret + 1] = { item.display_value:match("^%d+%."), "Special" }
        ret[#ret + 1] = { " " }
        local formatted_name = item.text:gsub("_", "/")
        ret[#ret + 1] = { formatted_name, "Normal" }
        return ret
    end,
    confirm = function(self, item)
        self:close()
        require("resession").load(item.text)
    end,
    actions = {
        delete_session = function(self, item)
            print("Deleted: " .. item.text)
            require("resession").delete(item.text)
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
