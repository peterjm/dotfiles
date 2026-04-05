-- Set leader before loading plugins
vim.g.mapleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins from lua/plugins/
require("lazy").setup("plugins", {
  headless = {
    log = false,
    task = false,
    process = false,
  },
})
