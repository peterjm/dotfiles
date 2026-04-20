-- Code formatting. conform.nvim runs formatters on save; mason-tool-installer keeps them installed.
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- lazy-load right before the first save
    cmd = { "ConformInfo" }, -- also load on :ConformInfo (useful for debugging)
    config = function()
      require("conform").setup({
        -- Which formatters to run per filetype. Lists run in sequence (e.g. isort then black).
        formatters_by_ft = {
          python = { "isort", "black" },
          lua = { "stylua" },
        },
        -- Automatically format on save. Falls back to the LSP's formatter if no conform formatter is configured.
        format_on_save = {
          timeout_ms = 3000,
          lsp_format = "fallback",
        },
      })
    end,
  },
  {
    -- Ensures the formatters above are installed via Mason without needing to run :Mason manually.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = { "black", "isort", "stylua" },
      })
    end,
  },
}
