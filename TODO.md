# Neovim Inline LLM Plugin - Implementation Tasks

## Core Principle: Ship Working Code Fast
Following Carmack's philosophy: "Get it working first, understand the problem space, then refactor if needed."

## Phase 1: Single Module Implementation

### Initial Setup
- [x] Create `lua/user/llm.lua` with module skeleton containing empty `M = {}` table and `return M`
- [x] Add basic `M.setup(opts)` function that merges user config with defaults: `model = "mistral"`, `url = "http://localhost:11434"`, `timeout = 30000`, `keymap = "<leader>ll"`
- [x] Add curl availability check in setup: `if vim.fn.executable('curl') == 0 then` notify error and return early
- [x] Add plugin entry to `lua/user/plugins/tools/init.lua`: `{ "local-llm", cmd = "LLMQuery", config = function() require("user.llm").setup() end }` (updated: moved to init.lua deferred loading to avoid lazy.nvim clone issues)
- [x] Add command and keymap creation to setup function: `vim.api.nvim_create_user_command('LLMQuery', handle_query, {range = true, desc = "Query LLM"})` and `vim.keymap.set('v', M.config.keymap, ':LLMQuery<CR>', {noremap = true, silent = true, desc = "Query LLM"})`

### Visual Selection Extraction
- [x] Implement `get_visual_selection()` function using `vim.fn.getpos("'<")` and `vim.fn.getpos("'>")` to get start/end positions
- [x] Handle partial line selection by trimming first line from `start_pos[3]` and last line to `end_pos[3]` 
- [x] Return concatenated lines with newlines preserved using `table.concat(lines, '\n')`
- [x] Add defensive check for empty selection and return empty string

### HTTP Client Implementation
- [x] Create `query_llm(prompt, callback)` function with local `response_data = {}` table for accumulating chunks
- [x] Build curl command array: `{'curl', '-s', '-X', 'POST', url .. '/api/generate', '-H', 'Content-Type: application/json', '-d', json_payload, '--max-time', timeout}`
- [x] Use `vim.fn.json_encode()` to create request payload with fields: `model`, `prompt`, `stream = false`
- [x] Implement jobstart with `on_stdout` handler that extends `response_data` table with incoming chunks
- [x] Add `on_exit` handler wrapped in `vim.schedule()` to ensure UI updates happen in main thread
- [x] Parse response with `pcall(vim.fn.json_decode, response)` and extract `json.response` field
- [x] Call provided callback with response text on success, show error notification on failure
- [x] Return job_id from jobstart for potential cancellation support

### Response Insertion
- [x] Create `insert_response(text, after_line)` function that splits text by newlines
- [x] Transform each line by prepending `> ` for markdown blockquote formatting
- [x] Use `vim.api.nvim_buf_set_lines(0, after_line, after_line, false, quoted_lines)` to insert after selection
- [x] Handle empty responses gracefully by checking line count before insertion

### Command Integration
- [x] Implement `handle_query(args)` as main orchestration function
- [x] Extract visual selection and validate it's not empty, show warning notification if empty
- [x] Display "Querying LLM..." notification before making request
- [x] Capture `vim.fn.line("'>")` as insertion point before async call
- [x] Call `query_llm()` with selection as prompt and callback that inserts response
- [x] Show "Response received" notification after successful insertion

### User Interface
- [x] Register `:LLMQuery` command with `vim.api.nvim_create_user_command()` with `range = true` and descriptive `desc` (consolidated in setup function)
- [x] Create visual mode keymap using `vim.keymap.set('v', M.config.keymap, ':LLMQuery<CR>', {noremap = true, silent = true})` (consolidated in setup function)
- [x] Ensure keymap respects user configuration by using `M.config.keymap` value (consolidated in setup function)
- [x] Add `desc = "Query LLM"` to keymap options for which-key integration (consolidated in setup function)

## Phase 2: Testing & Validation

### Manual Testing Checklist
- [x] Test with single line selection in markdown file
- [x] Test with multi-line selection including code blocks
- [x] Test with empty selection to verify warning notification
- [x] Test with Ollama not running to verify error handling
- [x] Test with network timeout by setting very low timeout value
- [x] Test with large response (>100 lines) to verify performance
- [x] Test cursor position after response insertion
- [x] Test undo behavior - single undo should remove entire response

### Edge Cases
- [x] Handle malformed JSON response from Ollama gracefully
- [x] Test with selection at end of file (no trailing newline)
- [x] Verify blockquote formatting preserves empty lines in response
- [x] Test rapid successive queries to ensure no race conditions
- [x] Verify memory cleanup - no leaked job processes

## Phase 3: Documentation

### Code Documentation
- [x] Add module-level comment explaining purpose and Ollama dependency
- [x] Document config options in setup function with types and defaults
- [x] Add usage example in comment block showing visual selection workflow
- [x] Include troubleshooting note about curl requirement

### User Documentation
- [x] Add section to README.md under "Features" describing LLM integration
- [x] Include configuration example showing all available options
- [x] Document required Ollama setup with link to installation guide
- [ ] Add GIF/screenshot showing feature in action (optional, only if requested)

## Future Iterations (Based on Real Usage)

### Potential Enhancements (DO NOT IMPLEMENT UNTIL NEEDED)
- [ ] Streaming response support (only if users complain about latency)
- [ ] Multiple model support (only if users need model switching)
- [ ] Response caching (only if repeated queries become common)
- [ ] Custom prompts/templates (only if users request prompt engineering)
- [ ] Integration with cmp/snippets (only if workflow demands it)

## Success Criteria
- [ ] Plugin loads without errors on Neovim startup
- [ ] Visual selection + `<leader>ll` produces blockquoted LLM response
- [ ] Errors are handled gracefully with user-friendly notifications
- [ ] Total implementation time < 2 hours
- [ ] Code is under 300 lines in single file
- [ ] No external dependencies beyond curl and Ollama

## Carmack's Wisdom Applied
"The right solution for now is not the right solution forever, but the right solution forever rarely is a good solution for now."