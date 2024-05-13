return {
    "echasnovski/mini.files",
    keys = {
        {
            "<leader>ee",
            function()
                require("mini.files").open()
            end,
            desc = "Open mini.files (cwd)",
        },
    },
    config = function()
        require("mini.files").setup({
            windows = {
                width_focus = 40,
                width_nofocus = 40,
            },
        })

        local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
        local autocmd = vim.api.nvim_create_autocmd
        local _, MiniFiles = pcall(require, "mini.files")

        -- Cache for git status
        local gitStatusCache = {}
        local cacheTimeout = 2000 -- Cache timeout in milliseconds

        local function mapSymbols(status)
            local statusMap = {
                [" M"] = { symbol = "•", hlGroup = "GitSignsChange" }, -- Modified
                ["MM"] = { symbol = "≠", hlGroup = "GitSignsChange" }, -- Modified in index
                ["A "] = { symbol = "+", hlGroup = "GitSignsAdd" }, -- Added to the staging area, new file
                ["AA"] = { symbol = "≈", hlGroup = "GitSignsAdd" }, -- file is added in both working tree and index
                ["D "] = { symbol = "-", hlGroup = "GitSignsDelete" }, -- Deleted from the staging area
                ["AM"] = { symbol = "⊕", hlGroup = "GitSignsChange" }, -- added in working tree, modified in index
                ["AD"] = { symbol = "-•", hlGroup = "GitSignsChange" }, -- Added in the index and deleted in the working directory
                ["R "] = { symbol = "→", hlGroup = "GitSignsChange" }, -- Renamed in the index
                ["U "] = { symbol = "‖", hlGroup = "GitSignsChange" }, -- Unmerged path
                ["UU"] = { symbol = "⇄", hlGroup = "GitSignsChange" }, -- file is unmerged
                ["UA"] = { symbol = "⊕", hlGroup = "GitSignsChange" }, -- file is unmerged and added in working tree
                ["??"] = { symbol = "?", hlGroup = "GitSignsUntracked" }, -- Untracked files
                ["!!"] = { symbol = "!", hlGroup = "GitSignsIgnored" }, -- Ignored files
            }

            local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
            return result.symbol, result.hlGroup
        end

        local function fetchGitStatus(cwd, callback)
            local stdout = (vim.uv or vim.loop).new_pipe(false)
            local handle, pid
            handle, pid = (vim.uv or vim.loop).spawn(
                "git",
                {
                    args = { "status", "--ignored", "--porcelain" },
                    cwd = cwd,
                    stdio = { nil, stdout, nil },
                },
                vim.schedule_wrap(function(code, signal)
                    if code == 0 then
                        stdout:read_start(function(err, content)
                            if content then
                                callback(content)
                                vim.g.content = content
                            end
                            stdout:close()
                        end)
                    else
                        vim.notify("Git command failed with exit code: " .. code, vim.log.levels.ERROR)
                        stdout:close()
                    end
                end)
            )
        end

        local function escapePattern(str)
            return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        end

        local function updateMiniWithGit(buf_id, gitStatusMap)
            vim.schedule(function()
                local nlines = vim.api.nvim_buf_line_count(buf_id)
                local cwd = vim.fn.getcwd()
                local escapedcwd = escapePattern(cwd)
                if vim.fn.has("win32") == 1 then
                    escapedcwd = escapedcwd:gsub("\\", "/")
                end

                for i = 1, nlines do
                    local entry = MiniFiles.get_fs_entry(buf_id, i)
                    if not entry then
                        break
                    end
                    local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
                    local status = gitStatusMap[relativePath]

                    if status then
                        local symbol, hlGroup = mapSymbols(status)
                        vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
                            sign_text = symbol,
                            sign_hl_group = hlGroup,
                            priority = 2,
                        })
                    else
                    end
                end
            end)
        end

        local function is_valid_git_repo()
            if vim.fn.isdirectory(".git") == 0 then
                return false
            end
            return true
        end

        -- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
        local function parseGitStatus(content)
            local gitStatusMap = {}
            -- lua match is faster than vim.split (in my experience )
            for line in content:gmatch("[^\r\n]+") do
                local status, filePath = string.match(line, "^(..)%s+(.*)")
                -- Split the file path into parts
                local parts = {}
                for part in filePath:gmatch("[^/]+") do
                    table.insert(parts, part)
                end
                -- Start with the root directory
                local currentKey = ""
                for i, part in ipairs(parts) do
                    if i > 1 then
                        -- Concatenate parts with a separator to create a unique key
                        currentKey = currentKey .. "/" .. part
                    else
                        currentKey = part
                    end
                    -- If it's the last part, it's a file, so add it with its status
                    if i == #parts then
                        gitStatusMap[currentKey] = status
                    else
                        -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
                        if not gitStatusMap[currentKey] then
                            gitStatusMap[currentKey] = status
                        end
                    end
                end
            end
            return gitStatusMap
        end

        local function updateGitStatus(buf_id)
            if not is_valid_git_repo() then
                return
            end
            local cwd = vim.fn.expand("%:p:h")
            local currentTime = os.time()
            if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
                updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
            else
                fetchGitStatus(cwd, function(content)
                    local gitStatusMap = parseGitStatus(content)
                    gitStatusCache[cwd] = {
                        time = currentTime,
                        statusMap = gitStatusMap,
                    }
                    updateMiniWithGit(buf_id, gitStatusMap)
                end)
            end
        end

        local function clearCache()
            gitStatusCache = {}
        end

        local function augroup(name)
            return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
        end

        autocmd("User", {
            group = augroup("start"),
            pattern = "MiniFilesExplorerOpen",
            -- pattern = { "minifiles" },
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                updateGitStatus(bufnr)
            end,
        })

        autocmd("User", {
            group = augroup("close"),
            pattern = "MiniFilesExplorerClose",
            callback = function()
                clearCache()
            end,
        })

        autocmd("User", {
            group = augroup("update"),
            pattern = "MiniFilesBufferUpdate",
            callback = function(sii)
                local bufnr = sii.data.buf_id
                local cwd = vim.fn.expand("%:p:h")
                if gitStatusCache[cwd] then
                    updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
                end
            end,
        })
    end,
}
