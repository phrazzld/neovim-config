return function(use)
	use("junegunn/goyo.vim")
	use({ "ellisonleao/glow.nvim", branch = "main" })
	use("preservim/vim-markdown")
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
end
