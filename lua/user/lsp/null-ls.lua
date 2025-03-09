local ok, null_ls = pcall(require, "null-ls")
if not ok then
	vim.notify("Failed to load null-ls", vim.log.levels.WARN)
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Create formatting autocommand group
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Configure null-ls
null_ls.setup({
	debug = false,
	sources = {
		-- Formatters
		formatting.prettier,
		formatting.stylua,
		formatting.rustfmt,
		
		-- Diagnostics
		diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc.js",
					".eslintrc.json",
					".eslintrc.yaml",
					".eslintrc.yml",
				})
			end,
		}),
	},
	
	-- Set up formatting on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			
			-- Organize imports for TypeScript/JavaScript files
			if vim.bo[bufnr].filetype == "typescript" or vim.bo[bufnr].filetype == "javascript" or
				vim.bo[bufnr].filetype == "typescriptreact" or vim.bo[bufnr].filetype == "javascriptreact" then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.execute_command({
							command = "_typescript.organizeImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
						})
					end,
				})
			end
			
			-- Format on save for all files
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ 
						async = false,
						bufnr = bufnr,
						filter = function(client)
							-- Use null-ls for formatting
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
