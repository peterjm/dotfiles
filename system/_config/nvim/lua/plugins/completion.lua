-- nvim-cmp — autocomplete popup engine. Pulls suggestions from multiple "sources".
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- suggestions from attached language servers
    "hrsh7th/cmp-buffer", -- words from the current buffer
    "hrsh7th/cmp-path", -- filesystem paths
    "L3MON4D3/LuaSnip", -- snippet engine (required for cmp to handle LSP snippet responses)
    "saadparwaiz1/cmp_luasnip", -- bridges LuaSnip snippets into cmp's source list
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      -- Tell cmp how to expand a snippet when one is selected — delegated to LuaSnip.
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      -- Key bindings active while the completion menu is open.
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter confirms (auto-selects first if none highlighted)
        ["<C-Space>"] = cmp.mapping.complete(), -- manually trigger the menu
      }),
      -- Sources are searched in priority groups: LSP+snippets first,
      -- fall back to buffer words and filesystem paths if those are empty.
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
