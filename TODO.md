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

## Critical Issues - MERGE BLOCKERS

### 1. Fix Command-Line Argument Length Limit - CRITICAL
- **Problem**: File content passed as curl `-d` argument hits OS ARG_MAX limits (~128KB-2MB)
- **Impact**: Feature fails silently for moderately sized files (core use case)
- **Location**: `lua/user/llm.lua:131` (jobstart call)
- **Fix Required**: Use stdin instead of command-line argument:
  ```lua
  local curl_cmd = {
    'curl', '-s', '-X', 'POST',
    M.config.url .. '/api/generate',
    '-H', 'Content-Type: application/json',
    '--data-binary', '@-',  -- Read from stdin
    '--max-time', tostring(M.config.timeout / 1000),
    '--connect-timeout', '10'
  }
  
  local job_id = vim.fn.jobstart(curl_cmd, {
    stdin = json_payload,  -- Pass payload via stdin
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
  ```

### 2. Fix Parameter Order in build_full_context_prompt - HIGH
- **Problem**: Function signature `(selection, full_content)` but format uses `(full_content, selection)`
- **Impact**: Latent bug, works by coincidence but creates maintenance hazard
- **Location**: `lua/user/llm.lua:115-118`
- **Fix Required**: Align parameter order with usage:
  ```lua
  local function build_full_context_prompt(full_content, selection)
    return string.format(
      "File context:\n%s\n\nSpecific question about the highlighted text:\n%s",
      full_content, selection
    )
  end
  ```
  Update call site to: `build_full_context_prompt(full_content, selection)`

## Documentation
- [x] Update header comment in `lua/user/llm.lua` to mention full file context behavior
- [x] Add example showing how file context enhances responses

## Issues Deferred to Future Work

**Why these are NOT merge blockers for this PR:**

### Binary File Handling
- **Rationale**: Binary files aren't the target use case for LLM code analysis
- **Scope**: This PR is specifically about text-based development files
- **Future Work**: Can be addressed in follow-up enhancement

### Large File Performance Optimization  
- **Rationale**: Core feature works, optimization can be iterative
- **Scope**: This PR establishes the base functionality
- **Future Work**: Add size limits and truncation in separate PR

### Security Concerns (Sensitive Data Exposure)
- **Rationale**: Broader concern affecting entire LLM integration, not just this feature
- **Scope**: Outside scope of this specific feature PR
- **Future Work**: Needs holistic approach across all LLM interactions

### Documentation Inconsistencies (Timeout Values)
- **Rationale**: Minor documentation issue, doesn't affect functionality
- **Scope**: Not critical for feature delivery
- **Future Work**: Documentation cleanup pass

### Hardcoded Prompt Format
- **Rationale**: Enhancement request, current format works for core use case
- **Scope**: Feature enhancement beyond initial implementation
- **Future Work**: Make configurable in v2