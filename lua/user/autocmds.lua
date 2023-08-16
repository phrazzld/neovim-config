-- format go code before save
--vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*.go",
--	command = [[ :silent! lua require('go.format').gofmt() ]],
--})

-- better formatting for text editing
-- markdown files
-- NOTE: vim doesn't know *.md files are markdown files
-- so we have to use VimEnter on the glob pattern
-- instead of FileType = markdown
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*.md",
	callback = function()
		vim.api.nvim_exec(
			[[
				nnoremap j gj
				nnoremap k gk
				setlocal wrap linebreak nolist cursorline!
		        ]],
			false
		)
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*.md",
	callback = function()
		vim.api.nvim_exec([[ Goyo ]], false)
	end,
})

-- text files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text",
	command = "setlocal wrap linebreak nolist cursorline!",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text",
	command = "nnoremap j gj",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text",
	command = "nnoremap k gk",
})

-- remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

-- toggle lualine with Goyo
vim.api.nvim_create_autocmd("User", {
	pattern = "GoyoEnter",
	command = [[lua require'lualine'.hide()]],
})
vim.api.nvim_create_autocmd("User", {
	pattern = "GoyoLeave",
	command = [[lua require'lualine'.hide({ unhide=true })]],
})

-- Automatically organize imports and format JS/TS code on save
-- Autocommands for TypeScript and JavaScript files
--[[ vim.api.nvim_create_autocmd("BufWritePre", { ]]
--[[ 	pattern = "*.ts,*.tsx,*.js,*.jsx", ]]
--[[ 	callback = function() ]]
--[[ 		vim.cmd("silent!") ]]
--[[ vim.lsp.buf.execute_command({ ]]
--[[ 	command = "_typescript.organizeImports", ]]
--[[ 	arguments = { vim.api.nvim_buf_get_name(0) }, ]]
--[[ }) ]]
--[[ 	vim.lsp.buf.format() ]]
--[[ end, ]]
--[[ }) ]]

-- Autocommands for Lua and Rust files
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua,*.rs,*.ts,*.tsx,*.js,*.jsx,*.svelte",
	callback = function()
		vim.lsp.buf.format()
	end,
})
