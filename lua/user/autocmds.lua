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

-- disable supermaven when in markdown files
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	callback = function()
		vim.api.nvim_exec([[ SupermavenStop ]], false)
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

-- Autocommands for Lua and Rust files
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua,*.rs,*.ts,*.tsx,*.js,*.jsx,*.svelte",
	callback = function()
		vim.lsp.buf.format()
	end,
})

-- format go code before save
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})

-- Lua configuration for Go formatting
vim.api.nvim_create_augroup("Go", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "Go",
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})
