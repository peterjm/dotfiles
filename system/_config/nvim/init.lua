-- Entry point for Neovim config. Loaded automatically on startup.

-- Set leader key to "," — used as a prefix for custom shortcuts (e.g. <leader>n).
-- Must be set before plugins load so their keymaps pick it up.
vim.g.mapleader = ","

-- Bootstrap lazy.nvim (the plugin manager) by cloning it if not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
-- Add lazy.nvim to the runtime path so `require("lazy")` works.
vim.opt.rtp:prepend(lazypath)

-- Load core config modules (options, keymaps, autocmds) from lua/config/.
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Hand off to lazy.nvim to load every plugin spec from lua/plugins/.
require("lazy").setup("plugins", {
  -- Silence lazy.nvim output when running headless (e.g. `nvim --headless`).
  headless = {
    log = false,
    task = false,
    process = false,
  },
})
