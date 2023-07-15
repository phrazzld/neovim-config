return function(use)
	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use("p00f/nvim-ts-rainbow") -- colored parens

	use("windwp/nvim-autopairs")

	-- easy comments
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- terminal
	use("akinsho/toggleterm.nvim")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- show colors in files
	use("norcalli/nvim-colorizer.lua")

	-- better indents
	use("tpope/vim-sleuth")

	-- vim sugar for unix shell commands
	use("tpope/vim-eunuch")

	-- make it easy to add surrounding characters
	use("tpope/vim-surround")
end
