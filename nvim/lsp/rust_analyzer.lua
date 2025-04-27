return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = function(bufnr, done)
        local fname = vim.api.nvim_buf_get_name(bufnr)

        local cargo_crate_dir = vim.fs.root(fname, "Cargo.toml")

        if cargo_crate_dir then
            local r = vim.system({
                "cargo",
                "metadata",
                "--no-deps",
                "--format-version",
                "1",
                "--manifest-path",
                cargo_crate_dir .. "/Cargo.toml",
            }):wait()

            if r.stdout then
                local result = vim.json.decode(r.stdout)
                if result["workspace_root"] then
                    local cargo_workspace_root = vim.fs.normalize(result["workspace_root"])
                    return done(cargo_workspace_root)
                end
            end

            return done(cargo_crate_dir)
        end

        local dotgit = vim.fs.root(fname, ".git")
        if dotgit then
            return done(dotgit)
        end
    end,
    capabilities = {
        experimental = {
            serverStatusNotification = true,
        },
    },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            cargo = {
                loadOutDirsFromCheck = true,
            },
        },
    },
}
