# LLM Full File Context - Core Feature

## Goal
When invoking LLM, pass the entire file as context with the highlighted text as the core message, and respond below the highlighted text.

## Core Implementation Tasks

### 1. Build Context Prompt
- [x] Implement `build_full_context_prompt()` function that combines:
  - Full file content as context
  - Selected text as the specific question/message
- [x] Format prompt as: `"File context:\n{full_file_content}\n\nSpecific question about the highlighted text:\n{selected_text}"`

### 2. Modify Existing Query Handler
- [x] Update `handle_query()` function to always include full file content as context
- [x] Preserve all existing error handling, async job management, and response insertion

### 3. Get Full File Content
- [x] Add `get_full_buffer_content()` function using `vim.api.nvim_buf_get_lines(0, 0, -1, false)`
- [x] Handle empty files gracefully (return empty string)

### 4. Response Positioning
- [x] Ensure response still inserts after the visual selection (existing behavior works)
- [x] Maintain existing blockquote formatting for responses

## Testing
- [x] Test with various file types: .md, .lua, .js, .py, etc.
- [x] Test edge cases: empty files, large files, binary files (fixed timeout issue)
- [x] Verify existing workflow: select text → `<leader>ll` → response appears below

## Bug Fixes
- [x] Fix timeout issue for large files by increasing default timeout from 30s to 120s

## Documentation
- [x] Update header comment in `lua/user/llm.lua` to mention full file context behavior
- [x] Add example showing how file context enhances responses