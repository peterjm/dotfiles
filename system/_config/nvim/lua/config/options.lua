local opt = vim.opt

opt.background = "dark"
opt.visualbell = true
opt.showcmd = true
opt.number = true
opt.cursorline = true
opt.list = true

opt.swapfile = false

opt.splitright = true
opt.splitbelow = true

-- Whitespace
opt.wrap = true
opt.linebreak = true
opt.showbreak = "+"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.textwidth = 120
opt.colorcolumn = "+1"

-- Searching
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- Use ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
end

-- Allow per-project config files (.nvim.lua, .nvimrc, .exrc)
opt.exrc = true
