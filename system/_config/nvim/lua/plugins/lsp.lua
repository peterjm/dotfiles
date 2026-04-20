-- LSP setup. Mason installs language servers; mason-lspconfig wires them into Neovim's built-in LSP client.
return {
  {
    -- Mason: installer UI for language servers, formatters, and linters.
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    -- mason-lspconfig: bridges Mason-installed LSPs with nvim-lspconfig's default configs.
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Language servers that should always be installed.
        ensure_installed = { "ruby_lsp", "lua_ls", "pyright" },
      })

      -- Advertise cmp's completion capabilities to each server so snippets / rich completion work.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Per-server configuration. lua_ls needs to know about the `vim` global so it doesn't warn about it.
      vim.lsp.config("ruby_lsp", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      -- Turn the configured servers on.
      vim.lsp.enable({ "ruby_lsp", "lua_ls", "pyright" })

      -- LSP-aware keybindings. Applied only to buffers where a language server has actually attached,
      -- so they don't shadow the default meanings of gd/gr/K in non-LSP buffers.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- jump to definition
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- list references
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- hover docs popup
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- code actions (quick fixes, etc.)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- rename symbol across project
        end,
      })
    end,
  },
}
