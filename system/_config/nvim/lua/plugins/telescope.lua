return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<C-P>", "<cmd>Telescope find_files<cr>" },
  },
}
