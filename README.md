# Neovim Configuration

My modern, modular Neovim setup optimized for performance, productivity, and aesthetics. Built entirely in Lua with the elegant Rose Pine colorscheme.

## Core Features

- **Performance-Optimized**: Lazy-loading plugins and deferred initialization for <100ms startup
- **Rose Pine Theme**: Clean, minimal aesthetic with light/dark mode toggle
- **Modern LSP Experience**: Intelligent code completion, diagnostics, and navigation
- **TypeScript Power Tools**: First-class support for TS/TSX with typescript-tools.nvim
- **Git Integration**: Seamless workflow with gitsigns and fugitive
- **Distraction-Free Writing**: Markdown support with Goyo and auto-formatting

## Key Plugins

- **Plugin Management**: lazy.nvim for performance-focused plugin loading
- **Fuzzy Finding**: Telescope for files, buffers, and project-wide search
- **Quick Navigation**: Hop.nvim for efficient cursor movement
- **File Browser**: NvimTree for directory exploration
- **Language Support**: TypeScript/JS, Lua, Go, Rust, Python, and more

## Installation

```bash
git clone https://github.com/phrazzld/neovim-config ~/.config/nvim
```

The first time you run Neovim, lazy.nvim will automatically install all plugins.

## Useful Keybindings

| Key           | Action                      |
|---------------|----------------------------|
| `<leader>th`  | Toggle light/dark theme    |
| `<leader>u`   | Find files (Telescope)     |
| `<leader>s`   | Search in files (Telescope)|
| `<leader>to`  | Organize TS imports        |
| `<leader>e`   | Toggle file explorer       |
| `<leader>gs`  | Git status                 |
| `<leader>xx`  | Toggle diagnostics panel   |
| `<C-f>f`      | Format current file        |

## Configuration Structure

- `init.lua`: Entry point that loads configuration modules
- `lua/user/`: Modular configuration files:
  - `lazy.lua`: Plugin manager setup (loads first)
  - `options.lua`: Core Neovim settings
  - `lsp/`: Language Server Protocol configuration
  - `colorscheme.lua`: Theme configuration
  - `keymappings.lua`: Global key bindings

## License

This configuration is available under the MIT License. See the [LICENSE](LICENSE) file for more details.