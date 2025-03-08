require("user.lazy")
require("user.options")
require("user.keymappings")
require("go").setup()
require("user.colorscheme")
require("user.cmp")
require("user.lsp")
require("user.telescope")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.nvim-tree")
require("user.toggleterm")
require("user.lualine")
require("user.markdown")
require("user.autocmds")
require("colorizer").setup()
require("user.trouble")
require("user.todo-comments")

-- Configure typescript-tools explicitly
require("typescript-tools").setup({
	-- Configure TypeScript tools with recommended settings
	settings = {
		-- Disable tsserver semantic tokens (already disabled in handlers)
		tsserver_file_preferences = {
			disableSuggestions = false,
			includeCompletionsForImportStatements = true,
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
		client.server_capabilities.semanticTokensProvider = nil
	end,
})

require("user.supermaven")
