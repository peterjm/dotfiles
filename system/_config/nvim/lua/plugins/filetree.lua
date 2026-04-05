return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<C-D>", "<cmd>NvimTreeToggle<cr>", silent = true },
    { "<C-F>", "<cmd>NvimTreeFindFile<cr>", silent = true },
  },
  config = function()
    require("nvim-tree").setup()
  end,
}
