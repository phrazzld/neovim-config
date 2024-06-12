return function(use)
	use("tjdevries/nlua.nvim")
	use("rust-lang/rust.vim")
	use("kchmck/vim-coffee-script")
	use("slim-template/vim-slim")
	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({})
		end,
	})
	-- golang
	use("ray-x/go.nvim")
end
