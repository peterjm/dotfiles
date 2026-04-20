-- Editor options. `vim.opt` is the Lua interface to `:set`.
local opt = vim.opt

-- UI appearance
opt.background = "dark" -- Tell colorschemes to use dark variants.
opt.visualbell = true -- Flash the screen instead of beeping on errors.
opt.showcmd = true -- Show partial commands (e.g. "d" while typing "dw") in the status line.
opt.number = true -- Show absolute line numbers in the gutter.
opt.cursorline = true -- Highlight the line the cursor is on.
opt.list = true -- Show invisible characters (tabs, trailing spaces) per `listchars`.

-- Don't create .swp swap files (I'd rather rely on undo history + git).
opt.swapfile = false

-- Use the system clipboard for all yanks, deletes, and pastes.
opt.clipboard = "unnamedplus"

-- When splitting windows, open the new one on the right / below rather than the default left / above.
opt.splitright = true
opt.splitbelow = true

-- Whitespace and wrapping
opt.wrap = true -- Soft-wrap long lines visually (no newline inserted).
opt.linebreak = true -- When wrapping, break at word boundaries rather than mid-word.
opt.showbreak = "+" -- Prefix wrapped-line continuations with "+" so they're visually distinct.
opt.tabstop = 2 -- A tab character renders as 2 columns wide.
opt.shiftwidth = 2 -- Auto-indent (>>, <<, =) uses 2 spaces per level.
opt.expandtab = true -- Pressing <Tab> inserts spaces instead of a tab character.

-- Line length guide: draw a colored column one past the textwidth (121) as a soft limit.
opt.textwidth = 120
opt.colorcolumn = "+1"

-- Searching
opt.hlsearch = false -- Don't keep search matches highlighted after the search finishes.
opt.ignorecase = true -- Case-insensitive search by default...
opt.smartcase = true -- ...unless the query contains an uppercase letter, then be case-sensitive.

-- Prefer ripgrep over the default grep for :grep — faster and respects .gitignore.
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
end

-- Allow per-project config files (.nvim.lua, .nvimrc, .exrc in the cwd).
-- Lets a project override settings without editing global config.
opt.exrc = true
