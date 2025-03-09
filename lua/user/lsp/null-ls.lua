local ok, null_ls = pcall(require, "null-ls")
if not ok then
	vim.notify("Failed to load null-ls", vim.log.levels.WARN)
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Create formatting autocommand group
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Safe source creation - only register sources that have executables available
local function safe_source(source_builder, executable_name)
	if not executable_name or vim.fn.executable(executable_name) == 1 then
		return source_builder
	end
	return nil
end

-- Configure null-ls
null_ls.setup({
	debug = false,
	sources = {
		-- Formatters
		safe_source(formatting.prettier, "prettier"),
		safe_source(formatting.stylua, "stylua"),
		safe_source(formatting.rustfmt, "rustfmt"),
		
		-- Diagnostics
		-- Prefer eslint_d if available, fallback to eslint
		(function()
			local eslint_config_files = {
				".eslintrc.js",
				".eslintrc.json",
				".eslintrc.yaml",
				".eslintrc.yml",
			}
			
			local condition = function(utils)
				return utils.root_has_file(eslint_config_files)
			end
			
			if vim.fn.executable("eslint_d") == 1 then
				return diagnostics.eslint_d.with({ condition = condition })
			elseif vim.fn.executable("eslint") == 1 then
				return diagnostics.eslint.with({ condition = condition })
			else
				return nil -- No eslint available, don't register the source
			end
		end)(),
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
						pcall(function()
							vim.lsp.buf.execute_command({
								command = "_typescript.organizeImports",
								arguments = { vim.api.nvim_buf_get_name(0) },
							})
						end)
					end,
				})
			end
			
			-- Format on save for all files
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					pcall(function()
						vim.lsp.buf.format({ 
							async = false,
							bufnr = bufnr,
							filter = function(client)
								-- Use null-ls for formatting
								return client.name == "null-ls"
							end,
						})
					end)
				end,
			})
		end
	end,
})