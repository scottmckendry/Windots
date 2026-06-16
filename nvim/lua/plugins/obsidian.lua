local obsidian_path = os.getenv("OBSIDIAN_PATH")
if not obsidian_path then
    return {}
end

local function search_tasks()
    local results = vim.fn.systemlist({
        "rg",
        "--no-heading",
        "--line-number",
        "--color=never",
        "--regexp",
        "^\\s*- \\[ \\]",
        obsidian_path,
    })
    local items = {}
    for _, line in ipairs(results) do
        local file, lnum, task = line:match("(.-):(%d+):%s*%- %[%s%] (.*)")
        if file and lnum then
            table.insert(items, {
                file = file,
                pos = { tonumber(lnum), 0 },
                text = task,
                note = vim.fn.fnamemodify(file, ":t:r"),
            })
        end
    end
    require("snacks").picker({
        title = "Tasks",
        items = items,
        format = function(item)
            return {
                { item.note, "Function" },
                { ":", "Comment" },
                { tostring(item.pos[1]), "Boolean" },
                { " " .. item.text, "Normal" },
            }
        end,
    })
end

return {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
        { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Daily note" },
        { "<leader>ot", "<cmd>Obsidian tomorrow<cr>", desc = "Apply Core Template" },
        { "<leader>on", "<cmd>Obsidian new_from_template Core<cr>", desc = "New Obsidian note" },
        { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes" },
        { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks" },
        { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },
        { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard" },
        { "<leader>ox", search_tasks, desc = "Search tasks" },
    },
    ---@type obsidian.config
    opts = {
        attachments = { folder = "attachments", confirm_img_paste = false },
        frontmatter = { enabled = false },
        new_notes_location = "notes_subdir",
        notes_subdir = "Zettelkasten",
        picker = { snacks = true },
        templates = { folder = "Templates", date_format = "%Y-%m-%d", time_format = "%H:%M" },
        daily_notes = { folder = "Daily", date_format = "%Y-%m-%d-%A", template = "Daily", default_tags = { "daily" } },
        ui = { enable = false },
        workspaces = { { name = "vault", path = obsidian_path } },

        note_id_func = function(title)
            if title ~= nil then
                return title
            else
                return vim.fn.input("Note title: ") or tostring(os.date("%Y%m%d%H%M"))
            end
        end,

        -- TODO: remove when the warning about legacy commands is gone
        legacy_commands = false,
    },
}
