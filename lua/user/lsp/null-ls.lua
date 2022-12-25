local ok, null_ls = pcall(require, "null-ls")
if not ok then
	return
end

local formatting = null_ls.builtins.formatting
--local diagnostics = null_ls.builtins.diagnostics

--[[ local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) ]]

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.stylua,
		formatting.rustfmt,
	},
	--on_attach = function(client, bufnr)
	--	if client.supports_method("textDocument/formatting") then
	--		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	--		vim.api.nvim_create_autocmd("BufWritePre", {
	--			group = augroup,
	--			pattern = "*.js,*.ts,*.jsx,*.tsx",
	--			command = [[
	--				:silent!
	--				lua vim.lsp.buf.execute_command({
	--					command = "_typescript.organizeImports",
	--					arguments = { vim.api.nvim_buf_get_name(0) },
	--				})
	--			]],
	--		})
	--		vim.api.nvim_create_autocmd("BufWritePre", {
	--			group = augroup,
	--			buffer = bufnr,
	--			callback = function()
	--				vim.lsp.buf.format()
	--			end,
	--		})
	--	end
	--end,
})
