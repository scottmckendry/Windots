local obsidian_path = vim.fn.getenv("OBSIDIAN_PATH")
if obsidian_path == nil then
    return {}
else
    return {
        "epwalsh/obsidian.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = "markdown",
        keys = {
            {
                "<leader>on",
                function()
                    vim.api.nvim_command("ObsidianNew")
                    vim.api.nvim_buf_set_lines(0, 0, -1, false, {}) -- Clear buffer
                    vim.api.nvim_command("ObsidianTemplate Core") -- Apply Core Template
                end,
                desc = "Create new note",
            },
            { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes" },
            { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks" },
            { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor" },
            { "<leader>ot", "<cmd>ObsidianTemplate Core<cr>", desc = "Apply Core Template" },
        },
        opts = {
            attachments = { img_folder = obsidian_path .. "/Files" },
            completion = { nvim_cmp = true },
            disable_frontmatter = true,
            new_notes_location = "notes_subdir",
            notes_subdir = "Zettelkasten",
            templates = { folder = obsidian_path .. "/Templates", date_format = "%y%m%d", time_format = "%H%M" },
            workspaces = { { name = "vault", path = obsidian_path } },

            note_id_func = function(title)
                if title ~= nil then
                    return title
                else
                    return os.date("%Y%m%d%H%M%S")
                end
            end,

            -- open external links in preferred browser
            follow_url_func = function(url)
                local cmd = { "xdg-open", url }
                if vim.fn.has("win32") == 1 then
                    cmd = { "explorer", url }
                end
                vim.fn.jobstart(cmd)
            end,
        },
    }
end
