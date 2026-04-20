-- nvim-tree — file explorer sidebar.
return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    -- Ctrl-D toggles the tree open/closed.
    { "<C-D>", "<cmd>NvimTreeToggle<cr>", silent = true },
    -- Ctrl-F opens the tree and jumps to the current file's location in it.
    { "<C-F>", "<cmd>NvimTreeFindFile<cr>", silent = true },
  },
  config = function()
    require("nvim-tree").setup()
  end,
}
