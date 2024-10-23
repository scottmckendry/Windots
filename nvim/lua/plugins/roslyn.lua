return {
    "seblj/roslyn.nvim",
    ft = { "cs" },
    -- TODO: Add build function that handles roslyn install until Mason supports it:
    -- https://github.com/mason-org/mason-registry/pull/6330
    config = function()
        local exe = nil
        if vim.fn.has("unix") == 1 then
            local os = vim.fn.systemlist("grep ^ID= /etc/os-release | cut -d= -f2")[1]
            if os == "nixos" then
                exe = { "Microsoft.CodeAnalysis.LanguageServer" }
            end
        end
        require("roslyn").setup({
            exe = exe,
        })
    end,
}
