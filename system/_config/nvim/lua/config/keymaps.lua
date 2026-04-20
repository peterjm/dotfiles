-- Custom keybindings. `map(mode, lhs, rhs)` binds `lhs` to `rhs` in the given mode.
local map = vim.keymap.set

-- `:src` re-sources this config without restarting Neovim.
map("n", ":src", ":source $MYVIMRC<CR>")

-- In visual mode, `.` repeats the last change on every selected line
-- (normal-mode `.` only repeats once).
map("v", ".", ":normal.<CR>")

-- Space runs the macro stored in register `q` — quick replay of whatever I just recorded with `qq`.
map("n", "<space>", "@q")

-- <leader>n toggles line numbers on/off (handy for copy-pasting from the terminal).
map("n", "<leader>n", ":set invnumber<CR>")

-- <leader>r reloads the current file from disk, discarding unsaved changes (`:e!` = force re-edit).
map("n", "<leader>r", ":e!<CR>")

-- <leader>jt pipes the entire buffer through Python's json.tool to pretty-print JSON.
map("n", "<leader>jt", ":%!python -m json.tool<CR>")

-- Convert old-style Ruby hashrocket syntax (`:key => value`) to modern shorthand (`key: value`).
-- Defined as a :map so it becomes a named command, then bound to <leader>h.
vim.cmd("map :RubyHashConvert :s/\\v:([^ ]+)\\s*\\=\\>/\\1:/g")
map("n", "<leader>h", ":RubyHashConvert<CR>")

-- :Rgrep — convenience wrapper around :grep that opens the quickfix list automatically.
-- With no argument, greps for the word under the cursor; otherwise takes a pattern.
vim.api.nvim_create_user_command("Rgrep", function(opts)
  local query = opts.args
  if query == "" then
    query = vim.fn.expand("<cword>")
  end
  vim.cmd("silent grep! " .. query)
  vim.cmd("copen") -- open the quickfix window listing matches
  vim.cmd("redraw!") -- redraw the screen (silent grep can leave it dirty)
end, { nargs = "?" })
-- <leader>f starts a :Rgrep command with the cursor waiting for a pattern.
map("n", "<leader>f", ":Rgrep<space>")
