return {
  "numToStr/comment.nvim",
  event = "VeryLazy",
  config = function()
    require('Comment').setup()
  end,
}
