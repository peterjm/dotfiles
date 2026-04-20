-- Jellybeans colorscheme (Lua port). Low-contrast dark theme.
return {
  "metalelf0/jellybeans-nvim",
  dependencies = { "rktjmp/lush.nvim" }, -- lush.nvim is the color DSL jellybeans-nvim is built on.
  priority = 1000, -- Load first, before any plugin that sets highlights.
  config = function()
    vim.cmd("colorscheme jellybeans-nvim")
  end,
}
