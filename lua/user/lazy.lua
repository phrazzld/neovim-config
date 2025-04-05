local M = {}

function M.setup()
	-- bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
	end
	vim.opt.runtimepath:prepend(lazypath)

	-- Leader keys must be set in init.lua before requiring this module
	-- Add any other vim options here
	-- vim.opt.example = value

	-- set up lazy.nvim
	require("lazy").setup({
		-- Import plugins by category from organized modules
		spec = {
			{ import = "user.plugins.core" },    -- Core plugins
			{ import = "user.plugins.editor" },  -- Editor enhancements
			{ import = "user.plugins.lsp" },     -- LSP and code intelligence
			{ import = "user.plugins.ui" },      -- UI components
			{ import = "user.plugins.tools" },   -- Tools and utilities
			{ import = "user.plugins.languages" }, -- Language-specific plugins
		},
		-- configure any other settings here
		-- colorscheme that will be used when installing plugins
		install = { colorscheme = { "rose-pine" } },
		-- automatically check for plugin updates
		checker = { enabled = true, frequency = 86400 }, -- check once a day
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					"matchit",
					"matchparen",
					"netrwPlugin",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
		},
	})
end

return M