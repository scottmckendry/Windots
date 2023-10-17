return {
    "iamcco/markdown-preview.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = function()
        local job = require("plenary.job")
        local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
        local cmd = "bash"

        if vim.fn.has("win64") == 1 then
            cmd = "pwsh"
        end

        job:new({
            command = cmd,
            args = { "-c", "npm install && git restore ." },
            cwd = install_path,
            on_exit = function()
                print("Finished installing markdown-preview.nvim")
            end,
            on_stderr = function(_, data)
                print(data)
            end,
        }):start()

        -- Options
        vim.g.mkdp_auto_close = 0
    end,
}
