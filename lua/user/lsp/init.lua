local ok, _ = pcall(require, "lspconfig")
if not ok then
	vim.notify("failed to init lspconfig")
	return
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"ts_ls",
		"lua_ls",
		"gopls",
		"bashls",
		"pyright",
	},
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
	["ts_ls"] = function()
		local ts_ls_opts = require("user.lsp.settings.ts_ls")
		opts = vim.tbl_deep_extend("force", ts_ls_opts, opts)
		require("lspconfig").ts_ls.setup(opts)
	end,
	["lua_ls"] = function()
		local lua_opts = require("user.lsp.settings.lua_ls")
		opts = vim.tbl_deep_extend("force", lua_opts, opts)
		require("lspconfig").lua_ls.setup(opts)
	end,
})

require("user.lsp.null-ls")
require("lspconfig").rust_analyzer.setup({})

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true, silent = true })
