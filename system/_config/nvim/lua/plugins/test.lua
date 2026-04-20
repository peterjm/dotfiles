-- vim-test — runs tests from inside Neovim. Auto-detects the right runner (rspec, pytest, etc.).
return {
  "vim-test/vim-test",
  keys = {
    { "t<C-n>", "<cmd>TestNearest<cr>", silent = true }, -- run the single test nearest the cursor
    { "t<C-f>", "<cmd>TestFile<cr>", silent = true }, -- run all tests in the current file
    { "t<C-s>", "<cmd>TestSuite<cr>", silent = true }, -- run the entire test suite
    { "t<C-l>", "<cmd>TestLast<cr>", silent = true }, -- re-run whatever was run last
    { "t<C-g>", "<cmd>TestVisit<cr>", silent = true }, -- jump to the file of the last-run test
  },
}
