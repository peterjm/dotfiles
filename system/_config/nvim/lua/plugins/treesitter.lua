return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "lua", "ruby", "javascript", "typescript", "python", "json", "yaml", "html", "css", "bash" },
      auto_install = true,
    })
  end,
}
