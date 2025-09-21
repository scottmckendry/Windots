-- TODO: Remove when roslyn supports lsp progress (properly)
-- See: https://github.com/dotnet/roslyn/issues/79939
return {
    handlers = {
        ["workspace/_roslyn_projectNeedsRestore"] = function()
            return {}
        end,
    },
}
