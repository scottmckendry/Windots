return {
    "IogaMaster/neocord",
    event = "VeryLazy",
    config = function()
        require("neocord").setup({
            editing_text = function(_)
                local ft = vim.bo.filetype
                if ft == "" then
                    return "Editing a file"
                end
                return "Editing a " .. ft .. " file"
            end,

            workspace_text = function(project_name)
                if project_name == nil then
                    return "💻 Just chilling"
                end

                local git_origin = vim.system({ "git", "config", "--get", "remote.origin.url" }):wait()

                -- Only display projects that I personally own or have forked, otherwise assume it's not something I want to share
                if string.find(git_origin.stdout, "scottmckendry") ~= nil then
                    return "Working on " .. project_name:gsub("%a", string.upper, 1) .. " 🚀"
                end

                return "Working on a private project 🤫"
            end,
        })
    end,
}
