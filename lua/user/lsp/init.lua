local ok, _ = pcall(require, "lspconfig")
if not ok then
	vim.notify("failed to init lspconfig")
	return
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "tsserver" },
})

local opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}
require("mason-lspconfig").setup_handlers({
	-- Default, runs for each installed server that doesn't have a dedicated handler
	function(server_name)
		require("lspconfig")[server_name].setup(opts)
	end,
	-- Targeted overrides
	["tsserver"] = function()
		local tsserver_opts = require("user.lsp.settings.tsserver")
		opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
		require("lspconfig").tsserver.setup(opts)
	end,
})

require("user.lsp.null-ls")
require("lspconfig").rust_analyzer.setup({})

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true, silent = true })
