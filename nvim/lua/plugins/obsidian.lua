local obsidian_path = vim.fn.getenv("OBSIDIAN_PATH")
if obsidian_path ~= nil then
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
            { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note", mode = "n" },
            { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
            { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
            { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor", mode = "n" },
        },
        opts = {
            workspaces = {
                {
                    name = "vault",
                    path = obsidian_path,
                },
            },

            attachments = {
                img_folder = obsidian_path .. "/4 Archive/Attachments",
            },

            completion = {
                nvim_cmp = true,
            },

            note_id_func = function(title)
                if title ~= nil then
                    return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- fallback to timestamp
                    return os.date("%Y%m%d%H%M%S")
                end
            end,

            note_frontmatter_func = function(note)
                local out = { tags = note.tags }

                if note.metadata ~= nil then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end

                return out
            end,
        },
    }
end
