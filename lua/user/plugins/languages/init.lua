-- Language-specific plugins
return {
	-- Firestore
	{ "delphinus/vim-firestore", ft = "firestore" },
	
	-- Lua
	{ "tjdevries/nlua.nvim", ft = "lua" },
	
	-- Rust
	{ "rust-lang/rust.vim", ft = "rust" },
	
	-- CoffeeScript
	{ "kchmck/vim-coffee-script", ft = "coffee" },
	
	-- Slim templates
	{ "slim-template/vim-slim", ft = "slim" },
	
	-- TypeScript
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "tsx", "jsx" },
		config = function()
			require("typescript-tools").setup({
				settings = {
					-- Expose organize imports as a code action
					expose_as_code_action = { "organize_imports" },
					tsserver_file_preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsWithSnippetText = true,
						includeAutomaticOptionalChainCompletions = true,
						includeCompletionsWithClassMembersSnippets = true,
						includeCompletionsWithInsertText = true,
						quotePreference = "auto",
					},
				},
				-- Explicitly disable semantic tokens
				on_attach = function(client, bufnr)
					-- Safely check and disable semantic tokens
					if client.server_capabilities and client.server_capabilities.semanticTokensProvider then
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- Add buffer-local keymaps
					vim.keymap.set(
						"n",
						"<leader>to",
						"<cmd>TSToolsOrganizeImports<CR>",
						{ noremap = true, silent = true, buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"<C-f>o",
						"<cmd>TSToolsOrganizeImports<CR>",
						{ noremap = true, silent = true, buffer = bufnr }
					)
				end,
			})
		end,
	},
	
	-- Golang
	{ "ray-x/go.nvim", ft = "go" },
	
	-- Markdown
	{ "preservim/vim-markdown", ft = "markdown" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { 
			"nvim-treesitter/nvim-treesitter", 
			"kyazdani42/nvim-web-devicons" 
		},
		ft = "markdown",
		config = function()
			require("user.markdown").setup()
		end,
	},
}