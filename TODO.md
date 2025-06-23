# Neovim LLM Plugin - Merge Blockers Only

## Core Philosophy: Ship Working Code
Following Carmack's approach: Fix functional correctness and data integrity issues. Everything else can wait for post-merge iterations based on real user feedback.


## MERGE BLOCKERS (Code Review Findings)
**What Would John Carmack Do?** Fix functional correctness and data integrity issues before merge. Everything else can wait.

### Critical Bug Fixes - MUST FIX BEFORE MERGE
- [x] **JSON Response Corruption** (lua/user/llm.lua:119): Change `table.concat(response_data, '\n')` to `table.concat(response_data, '')` - Current implementation fragments JSON by inserting newlines between stdout chunks, causing plugin to fail for any response >4KB
- [x] **Stale Visual Selection Security Issue** (lua/user/llm.lua:69-83): Add mode validation in `get_visual_selection()` - Currently sends arbitrary previous selection content to LLM when called outside visual mode, creating data leakage risk
- [x] **Asynchronous Buffer Corruption** (lua/user/llm.lua:175-207): Replace static `insert_line` with buffer marks in `handle_query()` - Current implementation corrupts buffers by inserting at stale line numbers after async operations

### Implementation Details for Blockers
```lua
-- Fix 1: JSON concatenation (line 138)
local response = table.concat(response_data, '') -- Remove '\n' separator

-- Fix 2: Visual selection validation (start of get_visual_selection)
local mode = vim.fn.mode()
if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then return "" end

-- Fix 3: Buffer mark safety (in handle_query)
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_mark(bufnr, 'L', vim.fn.line("'>"), 0, {})
-- Then resolve mark in callback: local mark_pos = vim.api.nvim_buf_get_mark(bufnr, 'L')
```

## Merge Criteria
- [x] **MERGE BLOCKERS FIXED**: JSON parsing works for large responses, no data leakage, no buffer corruption
- [ ] Basic functionality verified: Visual selection + `<leader>ll` produces blockquoted LLM response

## Post-Merge: Quality Improvements for Future Iterations
*Based on real user feedback and usage patterns:*
- Setup function idempotence (config reload issues)
- Enhanced error diagnostics (stderr capture)
- Buffer safety improvements
- Configuration validation
- Resource management
- Concurrent query handling

**Carmack's Wisdom**: "Perfect is the enemy of good. Ship working code, then iterate."