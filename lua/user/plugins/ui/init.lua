-- UI enhancements
return {
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("user.lualine").setup()
		end,
	},

	-- file tree
	{ "kyazdani42/nvim-web-devicons", lazy = true },
	{
		"kyazdani42/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		config = function()
			require("user.nvim-tree").setup()
		end,
	},

	-- show colors in files
	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			require("colorizer").setup()
		end,
	},
}
