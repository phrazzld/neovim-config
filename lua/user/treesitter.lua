local M = {}

function M.setup()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		return
	end

	treesitter.setup({
		ensure_installed = {
			"lua",
			"markdown",
			"markdown_inline",
			"bash",
			"javascript",
			"typescript",
			"tsx",
			"latex", -- Added for render-markdown.nvim LaTeX support
			"html",  -- Added for render-markdown.nvim HTML comment support
		},
		sync_install = false,
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	})
end

return M