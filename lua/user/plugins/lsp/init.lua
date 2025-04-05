-- LSP and code intelligence
return {
	-- lsp core
	{ "williamboman/mason.nvim", event = "VeryLazy" },
	{ "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{ "jose-elias-alvarez/null-ls.nvim", event = "VeryLazy" },
	
	-- treesitter (syntax highlighting and code understanding)
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
	
	-- diagnostics and code quality tools
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
}