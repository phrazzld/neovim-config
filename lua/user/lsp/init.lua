local ok, _ = pcall(require, "lspconfig")
if not ok then
  vim.notify("failed to init lspconfig")
  return
end

require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
require("lspconfig").rust_analyzer.setup({})
