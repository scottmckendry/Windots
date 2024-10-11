local obsidian_path = os.getenv("OBSIDIAN_PATH")
if not obsidian_path then
    return {}
end
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
        { "<leader>og", "<cmd>ObsidianGitSync<cr>", desc = "Sync changes to git" },
    },
    opts = {
        attachments = { img_folder = obsidian_path .. "/Files" },
        -- TODO: add blink.cmp integration when/if it's available
        -- completion = { nvim_cmp = true },
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

    config = function(_, opts)
        require("obsidian").setup(opts)
        local job = require("plenary.job")
        local update_interval_mins = 2

        -- check for any changes in the vault & pull them in
        local function pull_changes()
            job:new({
                command = "git",
                args = { "pull" },
                cwd = obsidian_path,
            }):start()
        end

        local function push_changes()
            vim.notify("Pushing updates...", 2, { title = "Obsidian.nvim" })
            job:new({
                command = "git",
                args = { "push" },
                cwd = obsidian_path,
            }):start()
        end

        local function commit_changes()
            local timestamp = os.date("%Y-%m-%d %H:%M:%S")
            job:new({
                command = "git",
                args = { "commit", "-m", "vault backup: " .. timestamp },
                cwd = obsidian_path,
                on_exit = function()
                    push_changes()
                end,
                on_stderr = function(_, data)
                    vim.notify("Error committing changes: " .. data, 2, { title = "Obsidian.nvim" })
                end,
            }):start()
        end

        local function stage_changes()
            vim.notify("Performing git sync...", 2, { title = "Obsidian.nvim" })
            job:new({
                command = "git",
                args = { "add", "." },
                cwd = obsidian_path,
                on_exit = function()
                    commit_changes()
                end,
                on_stderr = function(_, data)
                    vim.notify("Error staging changes: " .. data, 2, { title = "Obsidian.nvim" })
                end,
            }):start()
        end

        local function sync_changes()
            stage_changes()
            pull_changes()
        end

        local function schedule_update()
            vim.defer_fn(function()
                sync_changes()
                schedule_update()
            end, update_interval_mins * 60 * 1000)
        end

        schedule_update()

        vim.api.nvim_create_user_command("ObsidianGitSync", function()
            sync_changes()
        end, {})
    end,
}
