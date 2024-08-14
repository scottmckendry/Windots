return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        current_line_blame = true,
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns
            local function map(l, r, desc)
                vim.keymap.set("n", l, r, { buffer = buffer, desc = desc })
            end

            map("]h", gs.next_hunk, "Next Hunk")
            map("[h", gs.prev_hunk, "Prev Hunk")
            map("<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map("<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            map("<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("<leader>ghR", gs.reset_buffer, "Reset Buffer")
        end,
    },
}
