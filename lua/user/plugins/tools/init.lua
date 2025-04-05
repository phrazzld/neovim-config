-- Tools and utilities
return {
	-- navigation within files and projects
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("user.telescope").setup()
		end,
	},
	-- get around faster within a buffer
	{
		"smoka7/hop.nvim",
		version = "*",
		cmd = { "HopWord", "HopLine", "HopChar1" },
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
	},
	
	-- terminal integration
	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		config = function()
			require("user.toggleterm").setup()
		end,
	},
	
	-- git integration
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		config = function()
			require("user.gitsigns").setup()
		end,
	},
	{ "tpope/vim-fugitive", cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" } },
	
	-- vim sugar for unix shell commands
	{ "tpope/vim-eunuch", cmd = { "Rename", "Move", "Delete", "Mkdir", "Chmod", "SudoWrite" } },
}