# Neovim LLM Plugin - Merge Blockers Only

## Core Philosophy: Ship Working Code
Following Carmack's approach: Fix functional correctness and data integrity issues. Everything else can wait for post-merge iterations based on real user feedback.

## CRITICAL MERGE BLOCKERS
**What Would John Carmack Do?** Fix the 2 issues that prevent core functionality from working at all.

### BLOCKER 1: Visual Mode Check Breaks All User Workflows - MUST FIX
**Location**: `lua/user/llm.lua:71-74`
**Problem**: When user presses `<leader>ll` in visual mode, the mapping executes `:LLMQuery<CR>` which causes Neovim to exit visual mode BEFORE the Lua code runs. `vim.fn.mode()` returns `'n'`, failing the check every time.
**Impact**: Plugin is completely non-functional - every user interaction results in "No text selected"
**Fix**: Remove the mode check entirely. Visual marks `'<` and `'>` persist after exiting visual mode.
```lua
-- DELETE these lines from get_visual_selection():
-- local mode = vim.fn.mode()
-- if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
--     return ""
-- end
```

### BLOCKER 2: Race Condition Causes Data Corruption - MUST FIX  
**Location**: `lua/user/llm.lua:188` and `lua/user/llm.lua:200`
**Problem**: All concurrent queries share the same hardcoded mark name `'L'`. Multiple queries overwrite each other's insertion positions.
**Impact**: Severe data corruption - LLM responses insert at wrong locations
**Fix**: Use Neovim's extmark API with unique IDs:
```lua
-- In handle_query() replace nvim_buf_set_mark with:
local ns_id = vim.api.nvim_create_namespace("llm_plugin")
local mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, vim.fn.line("'>") - 1, 0, {})

-- In callback replace nvim_buf_get_mark with:
local mark_pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns_id, mark_id, {})
if not mark_pos then return end
vim.api.nvim_buf_del_extmark(bufnr, ns_id, mark_id)
local insert_line = mark_pos[1] + 1
```

## Merge Criteria
- [x] **BLOCKER 1 FIXED**: Remove visual mode check that prevents all user workflows
- [x] **BLOCKER 2 FIXED**: Replace shared mark with unique extmarks to prevent data corruption
- [ ] **Basic functionality verified**: Visual selection + `<leader>ll` produces blockquoted LLM response

## Post-Merge: Quality Improvements for Future Iterations
*Based on real user feedback and usage patterns:*

### Why These Are NOT Merge Blockers:
**Block-wise Visual Selection**: Current implementation sends full lines instead of rectangular block. This is a feature enhancement, not a functional blocker - basic visual selection still works for the primary use case.

**Missing Stderr Handling**: curl errors are reported via exit codes. While stderr capture would improve debugging, basic error handling already exists and functions correctly.

**Unbounded Concurrency**: Resource exhaustion from multiple simultaneous queries is possible but requires deliberate user action. Real-world usage patterns will inform whether this needs addressing.

**Mark Position Validation**: Edge case where mark is deleted during async operation. While good defensive programming, it's not preventing normal workflows from functioning.

**Keymap Cleanup**: Re-running setup() creates duplicate keymaps. This is a configuration management issue that doesn't break core functionality.

**Buffer Safety**: Additional validation for edge cases. Current implementation already handles the primary buffer management scenarios correctly.

### Deferred for Post-Merge (when guided by real usage):
- Enhanced error diagnostics (stderr capture) 
- Concurrency limits and job management
- Block-wise visual selection support
- Configuration reload handling
- Additional buffer safety checks
- Mark cleanup optimizations

**Carmack's Wisdom**: "Perfect is the enemy of good. Ship working code, then iterate based on real user feedback."