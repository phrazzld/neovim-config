# Neovim Startup Optimization Plan

This document outlines a structured, agile, and data-driven plan to optimize Neovim's startup time, reducing it from the current 1-3 seconds to a near-instant launch (target: <500ms). The approach involves iterative changes, each followed by measurement and validation, to address specific performance bottlenecks in the configuration. The plan prioritizes high-impact strategies first, leverages tools like Lazy.nvim for deferral, and uses profiling to guide further refinements.

---

## Identified Bottlenecks

The following issues contribute to slow startup times:
- **Numerous `require` statements in `init.lua`**: Forces plugins to load synchronously at startup, undermining lazy loading.
- **Large number of plugins**: Over 50 plugins, some unnecessary, increase overhead.
- **Synchronous operations**: Plugin setups (e.g., `require("go").setup()`) perform heavy initialization during startup.
- **Dynamic colorscheme selection**: Randomization and multiple colorscheme plugins add small delays.
- **LSP and Treesitter initialization**: Potential inefficiencies in early setup.
- **Autocommands**: Registered at startup, possibly adding minor overhead.

---

## Optimization Strategies (Prioritized by Impact)

1. **Defer Plugin Setup Using Lazy.nvim** (High Impact)
   Shift plugin loading to when needed, minimizing startup work.
2. **Reduce the Number of Plugins** (Moderate to High Impact)
   Decrease plugin overhead by removing non-essential ones.
3. **Simplify Colorscheme Selection** (Low to Moderate Impact)
   Eliminate dynamic switching overhead.
4. **Profile Startup Time** (High Potential, Diagnostic)
   Identify and target remaining bottlenecks.
5. **Consolidate Configuration Files** (Low Impact)
   Reduce `require` calls by merging small modules.
6. **Optimize Lua LSP Configuration** (Low Impact)
   Improve Lua editing performance, with minimal startup effect.
7. **Minimize Synchronous Operations** (Moderate Impact)
   Defer heavy tasks post-startup.

---

## Execution Plan

### 1. Defer Plugin Setup Using Lazy.nvim

**Goal**: Reduce startup time by deferring plugin loading until triggered by events, commands, or keymaps.

**Steps**:
- Identify all `require` statements in `init.lua` (e.g., `require("user.cmp")`, `require("user.telescope")`).
- Refactor each corresponding module (e.g., `user/cmp.lua`) to export a `setup` function:
  ```lua
  local M = {}
  M.setup = function()
    local cmp = require("cmp")
    cmp.setup({ ... }) -- Existing configuration
  end
  return M
  ```
- Update `lazy.lua` to configure plugins with appropriate triggers and call the `setup` function:
  - **CMP**: `{ "hrsh7th/nvim-cmp", event = "InsertEnter", config = function() require("user.cmp").setup() end }`
  - **Telescope**: `{ "nvim-telescope/telescope.nvim", cmd = "Telescope", config = function() require("user.telescope").setup() end }`
  - **Gitsigns**: `{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = function() require("user.gitsigns").setup() end }`
  - **Nvim-Tree**: `{ "kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = function() require("user.nvim-tree").setup() end }`
- Remove the `require` statements from `init.lua`.

**Measurement**:
- Run `nvim --startuptime startup.log` after each deferral.
- Analyze `startup.log` to confirm reduced startup time (e.g., from 3s to <1s).

**Trade-off**: Slight delay when first using a feature (e.g., entering insert mode for CMP).

---

### 2. Profile Startup Time

**Goal**: Pinpoint remaining bottlenecks after deferring plugins.

**Steps**:
- Generate a startup log: `nvim --startuptime startup.log`.
- Review the log to identify slow operations (e.g., specific plugins or autocommands).
- Use findings to prioritize subsequent optimizations (e.g., targeting a plugin taking 200ms).

**Measurement**:
- Compare logs before and after deferrals to quantify improvements.
- Target components exceeding 50ms for further optimization.

---

### 3. Reduce the Number of Plugins

**Goal**: Lower overhead by eliminating unnecessary plugins.

**Steps**:
- Audit `lazy.lua` to list all installed plugins.
- Remove or comment out non-essential plugins:
  - Examples: Multiple colorschemes (`catppuccin`, `tokyonight`), niche language plugins (`vim-coffee-script`).
- Consider lightweight alternatives (e.g., `oil.nvim` instead of `nvim-tree.lua`).
- Test functionality after each removal.

**Measurement**:
- Run `nvim --startuptime startup.log` after each change.
- Expect moderate reductions (e.g., 100-300ms per significant removal).

**Trade-off**: Loss of some features or conveniences.

---

### 4. Simplify Colorscheme Selection

**Goal**: Remove overhead from dynamic colorscheme switching.

**Steps**:
- Replace `require("user.colorscheme")` in `init.lua` with a fixed colorscheme:
  ```lua
  vim.cmd("colorscheme rose-pine")
  ```
- Remove unused colorscheme plugins from `lazy.lua` (e.g., keep only `rose-pine`).

**Measurement**:
- Check `startup.log` for a small reduction (e.g., 50-100ms).

**Trade-off**: No dynamic theme switching.

---

### 5. Consolidate Configuration Files

**Goal**: Minimize `require` calls by merging small modules.

**Steps**:
- Identify small configuration files (e.g., `user/options.lua`, `user/keymappings.lua`).
- Move their contents into `init.lua` or a single file (e.g., `user/config.lua`).
- Remove corresponding `require` statements from `init.lua`.

**Measurement**:
- Measure via `startup.log`; expect minor savings (e.g., 10-50ms).

**Trade-off**: Reduced modularity, potentially harder maintenance.

---

### 6. Optimize Lua LSP Configuration

**Goal**: Reduce LSP overhead for Lua files.

**Steps**:
- Modify `user/lsp/settings/lua_ls.lua`:
  ```lua
  workspace = {
    library = vim.api.nvim_get_runtime_file("", true),
    checkThirdParty = false,
  },
  ```
- Apply and test with a Lua file open.

**Measurement**:
- Minimal startup impact; verify via editing performance.

**Trade-off**: None significant.

---

### 7. Minimize Synchronous Operations

**Goal**: Shift heavy synchronous tasks post-startup.

**Steps**:
- Identify synchronous setups (e.g., `require("go").setup()`).
- Defer them using `vim.defer_fn`:
  ```lua
  vim.defer_fn(function() require("go").setup() end, 100)
  ```
- Apply selectively to avoid delaying critical features.

**Measurement**:
- Check `startup.log` for moderate gains (e.g., 50-200ms).

**Trade-off**: Delayed feature availability.

---

## General Guidelines

- **Version Control**:
  - Create a branch: `git checkout -b optimize-startup`.
  - Commit each optimization separately (e.g., `git commit -m "Defer CMP setup with Lazy.nvim"`).
- **Testing**:
  - After each change, verify keymaps, plugins, and core functionality.
- **Measurement**:
  - Use `nvim --startuptime startup.log` consistently.
  - Log results in a table (e.g., `| Step | Time (ms) | Notes |`).
- **Iteration**:
  - Revisit profiling after major changes to adjust priorities.
  - Stop when startup time is <500ms or diminishing returns are observed.

---

## Expected Outcomes

- **Initial Goal**: Reduce startup from 1-3s to <1s with deferrals (Step 1).
- **Stretch Goal**: Achieve <500ms with plugin reduction and further tweaks (Steps 2-7).
- **Data-Driven Adjustments**: Profiling ensures efforts focus on the most impactful areas.

By following this plan, Neovim’s startup will become significantly faster while retaining essential functionality, with each step validated through measurement and testing.
