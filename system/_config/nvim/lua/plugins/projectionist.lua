-- vim-projectionist — maps related files (e.g. jump from a model to its test) via JSON rules.
return {
  "tpope/vim-projectionist",
  lazy = false, -- must load on startup so heuristics are registered before :A/:Esomething is used
  init = function()
    -- Load custom project-structure heuristics from ~/.projectionist_heuristics.json if present.
    -- This lets me add project layouts projectionist doesn't know about out of the box.
    local path = vim.fn.expand("~/.projectionist_heuristics.json")
    if vim.fn.filereadable(path) == 1 then
      local json = table.concat(vim.fn.readfile(path), "\n")
      vim.g.projectionist_heuristics = vim.fn.json_decode(json)
    end
  end,
}
