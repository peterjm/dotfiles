-- Autocommands: event-driven hooks (fire on save, file open, filetype detection, etc.).
local autocmd = vim.api.nvim_create_autocmd

-- Map unrecognized file extensions to the right filetype so syntax/LSP/etc. work.
-- e.g. a `.jbuilder` file should be treated as Ruby.
vim.filetype.add({
  extension = {
    rabl = "ruby",
    god = "ruby",
    jbuilder = "ruby",
    ejs = "javascript",
  },
  pattern = {
    ["*.json.jbuilder"] = "ruby",
    ["*.json.erb"] = "javascript.eruby",
    ["*.htm.erb"] = "html.eruby",
  },
})

-- Makefiles require real tab characters — disable expandtab for those buffers only.
autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Python convention is 4-space indentation (PEP 8).
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Filetypes where I want whitespace normalization on save.
local whitespace_filetypes = { "ruby", "haml", "eruby", "javascript", "coffee", "handlebars", "yaml" }

-- Before writing the buffer, strip trailing whitespace and trailing blank lines.
-- Skipped if filetype isn't in the allowlist or if `g:clearwhitespace` is explicitly 0.
-- Saves cursor position so the cleanup doesn't jump you around.
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.tbl_contains(whitespace_filetypes, vim.bo.filetype) then
      return
    end
    if vim.g.clearwhitespace == 0 then
      return
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\s\+$//e]]) -- remove trailing spaces/tabs on every line
    vim.cmd([[silent! %s/\($\n\)\+\%$//]]) -- remove trailing blank lines at end of file
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- Before writing, convert any literal tabs to two spaces (same filetype/opt-out rules as above).
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.tbl_contains(whitespace_filetypes, vim.bo.filetype) then
      return
    end
    if vim.g.tabtospace == 0 then
      return
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\t/  /eg]])
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- When opening a file, jump to the cursor position where I last left it.
-- The `"` mark is Vim's auto-saved "last cursor position" mark for the buffer.
-- Skipped for git filetypes (commit messages, rebase todo lists) where starting at line 1 is preferable.
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype:match("^git") then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
