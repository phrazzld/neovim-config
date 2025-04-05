-- Core plugins (fundamentals that enable other plugins)
return {
	-- common dependencies
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- colorscheme
	{ "rose-pine/neovim", name = "rose-pine" },

	-- better indents
	{ "tpope/vim-sleuth" },

	-- help from robots
	{
		"supermaven-inc/supermaven-nvim",
		event = "VeryLazy",
		-- Configuration is handled in user/supermaven.lua
	},
}