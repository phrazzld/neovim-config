-- Only load the base requirements
require("user.lazy")
require("user.options")
require("user.keymappings")
require("user.colorscheme")
require("user.lsp")
require("user.markdown")
require("user.autocmds")

-- Go setup is deferred since it's heavy
vim.defer_fn(function()
	require("go").setup()
end, 100)

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