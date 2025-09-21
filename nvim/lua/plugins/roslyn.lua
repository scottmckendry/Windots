return {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = { "tris203/rzls.nvim", config = true },
    init = function()
        vim.filetype.add({
            extension = {
                razor = "razor",
                cshtml = "razor",
            },
        })
    end,
    config = function()
        require("roslyn").setup({ lock_target = true })

        local function build_cmd()
            local log_dir = vim.fs.dirname(vim.lsp.get_log_path())
            local cmd = {
                "roslyn",
                "--stdio",
                "--logLevel=Information",
                "--extensionLogDirectory=" .. log_dir,
            }

            local rzls_libexec = vim.fn.stdpath("data") .. "/mason/packages/rzls/libexec"
            table.insert(
                cmd,
                "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_libexec, "Microsoft.CodeAnalysis.Razor.Compiler.dll")
            )
            table.insert(
                cmd,
                "--razorDesignTimePath="
                    .. vim.fs.joinpath(rzls_libexec, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets")
            )
            table.insert(cmd, "--extension")
            table.insert(
                cmd,
                vim.fs.joinpath(rzls_libexec, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll")
            )

            return cmd
        end

        local handlers = (function()
            local ok, h = pcall(require, "rzls.roslyn_handlers")
            return ok and h or nil
        end)()

        vim.lsp.config("roslyn", {
            cmd = build_cmd(),
            handlers = handlers,
            settings = {
                ["csharp|code_lens"] = {
                    dotnet_enable_references_code_lens = true,
                },
            },
        })

        vim.lsp.enable("roslyn")
    end,
}
