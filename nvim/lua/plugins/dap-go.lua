-- NVim DAP Go https://github.com/leoluz/nvim-dap-go

local M = {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = "mfussenegger/nvim-dap",
  config = function(_, opts)
    require("dap-go").setup(opts)
  end
}

return M
