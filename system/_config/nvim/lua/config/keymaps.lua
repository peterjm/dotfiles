local map = vim.keymap.set

-- Re-source config
map("n", ":src", ":source $MYVIMRC<CR>")

-- Visual mode dot repeat
map("v", ".", ":normal.<CR>")

-- Use 'q' macro with space
map("n", "<space>", "@q")

-- Toggle line numbers
map("n", "<leader>n", ":set invnumber<CR>")

-- Refresh buffer
map("n", "<leader>r", ":e!<CR>")

-- Pretty-print JSON
map("n", "<leader>jt", ":%!python -m json.tool<CR>")

-- Replace hashrocket Ruby hashes with modern syntax
vim.cmd("map :RubyHashConvert :s/\\v:([^ ]+)\\s*\\=\\>/\\1:/g")
map("n", "<leader>h", ":RubyHashConvert<CR>")

-- Grep with quickfix
vim.api.nvim_create_user_command("Rgrep", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
  vim.cmd("redraw!")
end, { nargs = "+" })
map("n", "<leader>f", ":Rgrep<space>")
