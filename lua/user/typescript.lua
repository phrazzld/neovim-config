local M = {}

function M.setup()
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
end

return M