return {
  "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("lsp_diagnostic_float", { clear = true }),
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
      end,
      desc = "Show diagnostics in floating window",
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("pyright", { capabilities = capabilities })
    vim.lsp.config("ruff", { capabilities = capabilities })
    vim.lsp.enable({ "pyright", "ruff" })
  end,
}
