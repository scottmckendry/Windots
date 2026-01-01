local obsidian_path = os.getenv("OBSIDIAN_PATH")
if not obsidian_path then
    return {}
end

return {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
        { "<leader>on", "<cmd>Obsidian new_from_template Core<cr>", desc = "New Obsidian note" },
        { "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes" },
        { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks" },
        { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },
        { "<leader>ot", "<cmd>Obsidian template Core<cr>", desc = "Apply Core Template" },
        { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard" },

        -- Custom git sync job - manual trigger. Auto sync is available but off by default.
        -- Toggle on with <leader>to (toggle obsidian git sync)
        { "<leader>og", "<cmd>ObsidianGitSync<cr>", desc = "Sync changes to git" },
    },
    ---@type obsidian.config
    opts = {
        attachments = { folder = "attachments", confirm_img_paste = false },
        completion = { blink = true },
        frontmatter = { enabled = false },
        new_notes_location = "notes_subdir",
        notes_subdir = "Zettelkasten",
        picker = { snacks = true },
        preferred_link_style = "markdown",
        templates = { folder = "Templates", date_format = "%y%m%d", time_format = "%H%M" },
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
        local update_interval_mins = 2

        local function run_cmd(args, on_success, err_msg)
            vim.system(args, { cwd = obsidian_path }, function(obj)
                if obj.code == 0 then
                    if on_success then
                        on_success()
                    end
                elseif obj.stderr and obj.stderr ~= "" then
                    vim.schedule(function()
                        vim.notify(err_msg .. ": " .. obj.stderr, vim.log.levels.ERROR, { title = "Obsidian.nvim" })
                    end)
                end
            end)
        end

        local function sync_changes()
            vim.notify("Performing git sync...", vim.log.levels.INFO, { title = "Obsidian.nvim" })
            run_cmd({ "git", "pull" }, function()
                local timestamp = os.date("%Y-%m-%d %H:%M:%S")
                run_cmd({ "git", "add", "." }, function()
                    run_cmd({ "git", "commit", "-m", "vault backup: " .. timestamp }, function()
                        run_cmd({ "git", "push" }, nil, "Error pushing changes")
                    end, "Error committing changes")
                end, "Error staging changes")
            end, "Error pulling changes")
        end

        local function schedule_update()
            ---@diagnostic disable-next-line: unnecessary-if
            if not vim.g.obsidian_git_sync then
                return
            end
            vim.defer_fn(function()
                sync_changes()
                schedule_update()
            end, update_interval_mins * 60 * 1000)
        end

        schedule_update()
        vim.g.obsidian_git_sync = false

        vim.api.nvim_create_user_command("ObsidianGitSync", function()
            sync_changes()
        end, {})
    end,
}
