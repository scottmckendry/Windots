return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
        },
        filetypes = {
          markdown = true,
          yaml = true,
        },
      })
    end,
  }
