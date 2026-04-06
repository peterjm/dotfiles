return {
  "tpope/vim-projectionist",
  lazy = false,
  init = function()
    local path = vim.fn.expand("~/.projectionist_heuristics.json")
    if vim.fn.filereadable(path) == 1 then
      local json = table.concat(vim.fn.readfile(path), "\n")
      vim.g.projectionist_heuristics = vim.fn.json_decode(json)
    end
  end,
}
