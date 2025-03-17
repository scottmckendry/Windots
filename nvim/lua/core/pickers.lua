-- WIP: don't use!

local picker = require("snacks").picker

local items = {} ---@type snacks.picker.finder.Item[]
for _, session in ipairs(require("resession").list()) do
    items[#items + 1] = {
        text = session,
        value = session,
        display_value = #items + 1 .. ". " .. session,
    }
end

picker.pick({
    title = "Sessions",
    items = items,
    format = "text",
    layout = "select",
    confirm = function(self, item)
        self:close()
        print("Selected: " .. item.text)
    end,
})
