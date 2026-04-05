return {
  "vim-test/vim-test",
  keys = {
    { "t<C-n>", "<cmd>TestNearest<cr>", silent = true },
    { "t<C-f>", "<cmd>TestFile<cr>", silent = true },
    { "t<C-s>", "<cmd>TestSuite<cr>", silent = true },
    { "t<C-l>", "<cmd>TestLast<cr>", silent = true },
    { "t<C-g>", "<cmd>TestVisit<cr>", silent = true },
  },
}
