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
				event = "VeryLazy",
				config = function()
					require("supermaven-nvim").setup({})
				end,
			},

			-- common dependencies
			{ "nvim-lua/popup.nvim", lazy = true },
			{ "nvim-lua/plenary.nvim", lazy = true },

			-- colorscheme
			{ "rose-pine/neovim", name = "rose-pine" },

			-- lsp stuff
			{ "williamboman/mason.nvim", event = "VeryLazy" },
			{ "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
			{ "neovim/nvim-lspconfig", event = "VeryLazy" },
			{ "jose-elias-alvarez/null-ls.nvim", event = "VeryLazy" },
			{ "delphinus/vim-firestore", ft = "firestore" },

			-- completions
			{
				"hrsh7th/nvim-cmp",
				event = "InsertEnter",
				dependencies = {
					{ "hrsh7th/cmp-buffer", event = "InsertEnter" },
					{ "hrsh7th/cmp-path", event = "InsertEnter" },
					{ "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
					{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
					{ "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
					{
						"L3MON4D3/LuaSnip",
						event = "InsertEnter",
						dependencies = { "rafamadriz/friendly-snippets" },
					},
				},
				config = function()
					require("user.cmp").setup()
				end,
			},

			-- markdown
			{ "junegunn/goyo.vim", cmd = "Goyo" },
			{ "preservim/vim-markdown", ft = "markdown" },

			-- navigation
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
			-- file tree
			{ "kyazdani42/nvim-web-devicons", lazy = true },
			{
				"kyazdani42/nvim-tree.lua",
				cmd = "NvimTreeToggle",
				config = function()
					require("user.nvim-tree").setup()
				end,
			},
			-- floating statuslines
			{ "b0o/incline.nvim", event = "VeryLazy" },

			-- git
			{
				"lewis6991/gitsigns.nvim",
				event = "BufReadPost",
				config = function()
					require("user.gitsigns").setup()
				end,
			},
			{ "tpope/vim-fugitive", cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" } },

			-- snippets
			{ "L3MON4D3/LuaSnip", event = "InsertEnter" },
			{ "rafamadriz/friendly-snippets", event = "InsertEnter" },

			-- languages
			{ "tjdevries/nlua.nvim", ft = "lua" },
			{ "rust-lang/rust.vim", ft = "rust" },
			{ "kchmck/vim-coffee-script", ft = "coffee" },
			{ "slim-template/vim-slim", ft = "slim" },
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
				ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "tsx", "jsx" },
				-- Remove automatic setup since we're configuring it explicitly in init.lua
			},
			-- golang
			{ "ray-x/go.nvim", ft = "go" },

			-- treesitter
			{
				"nvim-treesitter/nvim-treesitter",
				build = function()
					local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
					ts_update()
				end,
				event = "VeryLazy",
				config = function()
					require("user.treesitter").setup()
				end,
			},
			{
				"p00f/nvim-ts-rainbow",
				event = "VeryLazy",
				dependencies = { "nvim-treesitter/nvim-treesitter" },
			}, -- colored parens

			{
				"windwp/nvim-autopairs",
				event = "InsertEnter",
				config = function()
					require("user.autopairs").setup()
				end,
			},

			-- easy comments
			{
				"numToStr/Comment.nvim",
				event = "BufReadPost",
				config = function()
					require("user.comment").setup()
				end,
			},
			{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },

			-- terminal
			{
				"akinsho/toggleterm.nvim",
				cmd = "ToggleTerm",
				config = function()
					require("user.toggleterm").setup()
				end,
			},

			-- statusline
			{
				"nvim-lualine/lualine.nvim",
				event = "VeryLazy",
				config = function()
					require("user.lualine").setup()
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

			-- better indents
			{ "tpope/vim-sleuth" },

			-- vim sugar for unix shell commands
			{ "tpope/vim-eunuch", cmd = { "Rename", "Move", "Delete", "Mkdir", "Chmod", "SudoWrite" } },

			-- make it easy to add surrounding characters
			{ "tpope/vim-surround", event = "BufReadPost" },

			-- todos and diagnostics
			{
				"folke/trouble.nvim",
				opts = {}, -- for default options, refer to the configuration section for custom setup.
				cmd = "Trouble",
				keys = {
					{
						"<leader>xx",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>xX",
						"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
						desc = "Buffer Diagnostics (Trouble)",
					},
					{
						"<leader>cs",
						"<cmd>Trouble symbols toggle focus=false<cr>",
						desc = "Symbols (Trouble)",
					},
					{
						"<leader>cl",
						"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
						desc = "LSP Definitions / references / ... (Trouble)",
					},
					{
						"<leader>xL",
						"<cmd>Trouble loclist toggle<cr>",
						desc = "Location List (Trouble)",
					},
					{
						"<leader>xQ",
						"<cmd>Trouble qflist toggle<cr>",
						desc = "Quickfix List (Trouble)",
					},
				},
			},
			{
				"folke/todo-comments.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				event = "VeryLazy",
				opts = { signs = false },
				keys = {
					{
						"<leader>xt",
						"<cmd>TodoQuickFix<cr>",
						desc = "Todos (TodoTelescope)",
					},
				},
			},
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