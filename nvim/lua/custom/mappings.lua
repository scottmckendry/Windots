local M = {}

M.splitscreen = {
  n = {
    ["<leader>sv"] = {
      "<cmd> vsplit <CR>",
      "Split screen vertically"
    },
    ["<leader>sh"] = {
      "<cmd> split <CR>",
      "Split screen horizontally"
    }
  }
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>ds"] = {
      function()
        require('dap').continue()
      end,
      "Start debugging"
    },
    ["<F5>"] = {
      function()
        require('dap').step_over()
      end,
      "Step over"
    },
    ["<S-F5>"] = {
      function()
        require('dap').step_into()
      end,
      "Step into"
    },
    ["<S-F6>"] = {
      function()
        require('dap').step_out()
      end,
      "Step out"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    },
    ["<leader>dgf"] = {
      function()
        require('dap-go').debug_file()
      end,
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}

return M
