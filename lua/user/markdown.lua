local M = {}

function M.setup()
	-- glow config
	vim.g.glow_style = "light"
	vim.g.glow_use_pager = true

	-- vim-markdown config
	vim.g.vim_markdown_folding_disabled = true
end

return M
