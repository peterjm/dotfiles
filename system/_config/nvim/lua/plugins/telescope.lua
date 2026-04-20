-- Telescope — fuzzy finder for files, grep results, buffers, etc.
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- shared Lua utility library Telescope is built on
  keys = {
    -- Ctrl-P opens a fuzzy file picker for the current project.
    { "<C-P>", "<cmd>Telescope find_files<cr>" },
  },
}
