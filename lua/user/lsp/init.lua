local M = {}

function M.setup()
	local ok, lspconfig = pcall(require, "lspconfig")
	if not ok then
		vim.notify("failed to init lspconfig", vim.log.levels.ERROR)
		return
	end

	-- Initialize the LSP handlers first to ensure they're available
	local handlers = require("user.lsp.handlers")
	handlers.setup()

	-- Set up Mason and Mason-lspconfig
	local mason_ok, mason = pcall(require, "mason")
	if not mason_ok then
		vim.notify("Failed to load Mason", vim.log.levels.ERROR)
		return
	end
	mason.setup()

	local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not mason_lspconfig_ok then
		vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
		return
	end

	mason_lspconfig.setup({
		ensure_installed = {
			"rust_analyzer",
			-- Remove ts_ls since we're using typescript-tools
			"lua_ls",
			"gopls",
			"bashls",
			"pyright",
			"jsonls",
		},
	})

	-- Default options for all servers
	local opts = {
		on_attach = handlers.on_attach,
		capabilities = handlers.capabilities,
	}

	-- Server-specific settings
	local servers = {
		["lua_ls"] = require("user.lsp.settings.lua_ls"),
		["jsonls"] = require("user.lsp.settings.jsonls"),
		["rust_analyzer"] = {},
	}

	mason_lspconfig.setup_handlers({
		-- Default handler for servers not explicitly configured
		function(server_name)
			-- Skip ts_ls since we're using typescript-tools instead
			if server_name == "ts_ls" then
				return
			end

			local server_opts = servers[server_name] or {}
			local final_opts = vim.tbl_deep_extend("force", server_opts, opts)
			lspconfig[server_name].setup(final_opts)
		end,
	})

	-- Set up null-ls
	require("user.lsp.null-ls").setup()

	-- Global keymapping for diagnostics
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true, silent = true })
end

return M
