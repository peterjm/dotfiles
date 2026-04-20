-- Commenting plugin. Adds `gcc` (toggle line comment) and `gc` + motion (toggle range).
return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
  end,
}
