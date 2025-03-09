local M = {}

function M.setup()
    local ok, ts_tools = pcall(require, "typescript-tools")
    if not ok then
        vim.notify("Failed to load typescript-tools", vim.log.levels.WARN)
        return
    end

    ts_tools.setup({
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

-- Function to check if TypeScript is available without loading it
function M.is_available()
    local ok, _ = pcall(require, "typescript-tools")
    return ok
end

return M