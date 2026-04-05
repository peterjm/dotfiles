local autocmd = vim.api.nvim_create_autocmd

-- Filetype detection
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

-- File types that require tabs
autocmd("FileType", {
  pattern = { "make", "python" },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Clear trailing whitespace on save
local whitespace_filetypes = { "ruby", "haml", "eruby", "javascript", "coffee", "handlebars", "yaml" }

autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.tbl_contains(whitespace_filetypes, vim.bo.filetype) then return end
    if vim.g.clearwhitespace == 0 then return end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.cmd([[silent! %s/\($\n\)\+\%$//]])
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- Convert tabs to spaces on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.tbl_contains(whitespace_filetypes, vim.bo.filetype) then return end
    if vim.g.tabtospace == 0 then return end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\t/  /eg]])
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- Remember last cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype:match("^git") then return end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
