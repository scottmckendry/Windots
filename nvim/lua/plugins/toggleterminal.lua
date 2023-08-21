-- Toggle Terminal https://github.com/akinsho/toggleterm.nvim
local M = {
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm size=20<cr>", desc = "Toggle Terminal", mode = "n" },
      { "<C-\\>", "<cmd>ToggleTerm<cr>",         desc = "Toggle Terminal", mode = "t" },
    },
    opts = {
      shade_terminals = false,
    },
  },
}

return M
