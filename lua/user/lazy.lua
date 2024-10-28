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

-- Set up leader keys and other settings before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Add any other vim options here
-- vim.opt.example = value

-- set up lazy.nvim
require("lazy").setup({
	spec = {
		-- help from robots
		{
			"supermaven-inc/supermaven-nvim",
			config = function()
				require("supermaven-nvim").setup({})
			end,
		},

		-- common dependencies
		{ "nvim-lua/popup.nvim" },
		{ "nvim-lua/plenary.nvim" },

		-- colorschemes
		{ "ellisonleao/gruvbox.nvim" },
		{ "folke/tokyonight.nvim" },
		{ "catppuccin/nvim", name = "catppuccin" },
		{ "rebelot/kanagawa.nvim" },
		{ "EdenEast/nightfox.nvim" },
		{ "projekt0n/github-nvim-theme" },
		{ "sainnhe/everforest" },
		{ "nyoom-engineering/oxocarbon.nvim" },
		{ "rose-pine/neovim", name = "rose-pine" },

		-- lsp stuff
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "jose-elias-alvarez/null-ls.nvim" },
		{ "delphinus/vim-firestore" },

		-- completions
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },

		-- markdown
		{ "junegunn/goyo.vim" },
		{ "preservim/vim-markdown" },

		-- navigation
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		},
		-- get around faster within a buffer
		{
			"smoka7/hop.nvim",
			version = "*",
			opts = {
				keys = "etovxqpdygfblzhckisuran",
			},
		},
		-- file tree
		{ "kyazdani42/nvim-web-devicons" },
		{ "kyazdani42/nvim-tree.lua" },
		-- floating statuslines
		{ "b0o/incline.nvim" },

		-- git
		{ "lewis6991/gitsigns.nvim" },
		{ "tpope/vim-fugitive" },

		-- snippets
		{ "L3MON4D3/LuaSnip" },
		{ "rafamadriz/friendly-snippets" },

		-- languages
		{ "tjdevries/nlua.nvim" },
		{ "rust-lang/rust.vim" },
		{ "kchmck/vim-coffee-script" },
		{ "slim-template/vim-slim" },
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = function()
				require("typescript-tools").setup({})
			end,
		},
		-- golang
		{ "ray-x/go.nvim" },

		-- treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			run = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		},
		{ "p00f/nvim-ts-rainbow" }, -- colored parens

		{ "windwp/nvim-autopairs" },

		-- easy comments
		{ "numToStr/Comment.nvim" },
		{ "JoosepAlviste/nvim-ts-context-commentstring" },

		-- terminal
		{ "akinsho/toggleterm.nvim" },

		-- statusline
		{ "nvim-lualine/lualine.nvim" },

		-- show colors in files
		{ "norcalli/nvim-colorizer.lua" },

		-- better indents
		{ "tpope/vim-sleuth" },

		-- vim sugar for unix shell commands
		{ "tpope/vim-eunuch" },

		-- make it easy to add surrounding characters
		{ "tpope/vim-surround" },
	},
	-- configure any other settings here
	-- colorscheme that will be used when installing plugins
	install = { colorscheme = { "tokyonight" } },
	-- automaticall check for plugin updates
	checker = { enabled = true },
})
