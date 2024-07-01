return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "danielfalk/smart-open.nvim",
        "kkharji/sqlite.lua",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        { "scottmckendry/telescope-resession.nvim", dev = true },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = function()
                local install_path = vim.fn.stdpath("data") .. "/lazy/telescope-fzf-native.nvim"
                vim.cmd("silent !cd " .. install_path .. " && make")
            end,
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        if vim.fn.has("win32") == 1 then
            vim.cmd("let g:sqlite_clib_path='/ProgramData/chocolatey/lib/SQLite/tools/sqlite3.dll'")
        end

        local select_one_or_multi = function(prompt_bufnr)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local multi = picker:get_multi_selection()
            if not vim.tbl_isempty(multi) then
                require("telescope.actions").close(prompt_bufnr)
                for _, j in pairs(multi) do
                    if j.path ~= nil then
                        vim.cmd(string.format("%s %s", "edit", j.path))
                    end
                end
            else
                require("telescope.actions").select_default(prompt_bufnr)
            end
        end

        local home_dir = os.getenv("HOME")
        if vim.fn.has("win32") == 1 then
            home_dir = "C:/Users/" .. vim.fn.expand("$USERNAME")
        end

        telescope.setup({
            extensions = {
                resession = {
                    path_substitutions = {
                        { find = home_dir .. "/git/", replace = "󰊢 " },
                    },
                },

                smart_open = {
                    match_algorithm = "fzf",
                },
            },
            pickers = {
                find_files = {
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    mappings = {
                        i = {
                            ["<c-d>"] = "delete_buffer",
                        },
                    },
                },
            },
            defaults = {
                hidden = true,
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",

                sorting_strategy = "ascending",
                layout_strategy = "horizontal",

                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                path_display = {
                    filename_first = {
                        reverse_directories = true,
                    },
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<cr>"] = select_one_or_multi,
                    },
                },
            },
        })

        require("telescope").load_extension("fzf")
        require("telescope").load_extension("smart_open")
    end,
}
