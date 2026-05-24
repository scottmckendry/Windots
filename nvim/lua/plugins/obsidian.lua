local obsidian_path = os.getenv("OBSIDIAN_PATH")
if not obsidian_path then
    return {}
end

return {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
        { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },
        { "<leader>on", "<cmd>Obsidian new_from_template Core<cr>", desc = "New Obsidian note" },
        { "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes" },
        { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks" },
        { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },
        { "<leader>ot", "<cmd>Obsidian template Core<cr>", desc = "Apply Core Template" },
        { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard" },
    },
    ---@type obsidian.config
    opts = {
        attachments = { folder = "attachments", confirm_img_paste = false },
        frontmatter = { enabled = false },
        new_notes_location = "notes_subdir",
        notes_subdir = "Zettelkasten",
        picker = { snacks = true },
        link = { style = "markdown" },
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

    config = function(_, opts)
        require("obsidian").setup(opts)

        -- Start livesync daemon via systemd user service
        -- Service defined in modules/desktop/livesync.nix, no autostart
        -- systemctl start is idempotent — no-op if already running
        local ok = vim.system({ "systemctl", "--user", "start", "livesync" }):wait()
        if ok.code ~= 0 then
            vim.notify(
                "livesync daemon failed to start (exit " .. ok.code .. ")",
                vim.log.levels.ERROR,
                { title = "LiveSync" }
            )
        end
    end,
}
