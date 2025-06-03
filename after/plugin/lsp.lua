local lsp_zero = require("lsp-zero")

lsp_zero.extend_lspconfig({
  sign_text = true,
})

require("mason").setup({})

require("mason-lspconfig").setup({
  ensure_installed = { "gopls" },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  }
})
