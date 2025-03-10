local M = {}

-- Helper function to set up document highlighting
local function _lsp_highlight_document(client, bufnr)
	-- set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = highlight_group,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = highlight_group,
		})
	end
end

-- Helper function to set up LSP keymaps
local function _lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ border = "rounded" }) end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ border = "rounded" }) end, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
	vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format({ async = true }) end, {})
end

function M.setup()
	-- Enable LSP logging for debugging
	vim.lsp.set_log_level("debug")
	
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
	
	-- Initialize capabilities with smart fallback
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if cmp_nvim_lsp_ok then
		M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	else
		M.capabilities = capabilities
		vim.notify("cmp_nvim_lsp not available, using basic capabilities", vim.log.levels.WARN)
	end
end

function M.on_attach(client, bufnr)
	if client.name == "ts_ls" then
		client.server_capabilities.document_formatting = false
	end
	
	-- Disable semantic tokens to fix the nvim__buf_redraw_range error
	-- Safely check and disable semantic tokens
	if client.server_capabilities and client.server_capabilities.semanticTokensProvider then
		client.server_capabilities.semanticTokensProvider = nil
	end
	
	_lsp_keymaps(bufnr)
	_lsp_highlight_document(client, bufnr)
end

return M