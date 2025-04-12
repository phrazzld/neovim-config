local M = {}

function M.setup()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		return
	end
	
	-- Configure TreeSitter installation parameters for proper ARM64 compilation
	local ts_install = require("nvim-treesitter.install")
	ts_install.prefer_git = true
	ts_install.compilers = { "clang" }
	
	-- Don't delete parser files every time - this causes reinstallation
	-- Only delete them once during manual repair

	treesitter.setup({
		ensure_installed = {
			"lua",
			-- Don't auto-install markdown parsers - we'll manually install them
			-- "markdown",
			-- "markdown_inline",
			"bash",
			"javascript",
			"typescript",
			"tsx",
			"latex", -- Added for render-markdown.nvim LaTeX support
			"html",  -- Added for render-markdown.nvim HTML comment support
		},
		sync_install = false, -- Don't force synchronous installation
		auto_install = false, -- Disable auto-install to prevent reinstallation
		highlight = { enable = true },
		indent = { enable = true },
	})
end

return M