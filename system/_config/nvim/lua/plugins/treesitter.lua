-- nvim-treesitter — incremental parsing for better syntax highlighting, indentation, and text objects.
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- after install/update, compile parsers for all installed languages
  config = function()
    require("nvim-treesitter").setup({
      -- Parsers installed on startup if missing.
      ensure_installed = {
        "lua",
        "ruby",
        "javascript",
        "typescript",
        "python",
        "json",
        "yaml",
        "html",
        "css",
        "bash",
      },
      -- Also install parsers on-demand the first time a new filetype is opened.
      auto_install = true,
    })
  end,
}
