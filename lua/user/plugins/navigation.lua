return function(use)
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})
	-- get around faster within a buffer
	use({
		"phaazon/hop.nvim",
		branch = "v1",
	})
	-- file tree
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	-- floating statuslines
	use("b0o/incline.nvim")
end
