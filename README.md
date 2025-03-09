# Neovim Config 🛠️

This repository contains my personal Neovim configuration, written in Lua. It is designed to provide an efficient and feature-rich development environment with the Rose Pine colorscheme, robust LSP support, and efficient code navigation.

## Features ✨

- **Rose Pine Theme**: Beautiful and consistent colorscheme with light/dark mode support
- **Full LSP Support**: Integrated with Mason for easy LSP server management
- **Intelligent Code Completion**: Using nvim-cmp with LSP integration
- **Fast Navigation**: Telescope for fuzzy finding and Hop for quick movement
- **Git Integration**: Gitsigns and Fugitive for seamless Git workflows
- **Diagnostic Tools**: Trouble.nvim and todo-comments for easy issue tracking
- **Language Support**: Preconfigured for TypeScript, Lua, Go, Rust, Python, and more

## Structure 📁

- `init.lua`: Main entry point that loads all modules
- `lua/user/`: Contains modular configuration files:
  - `lazy.lua`: Plugin management using lazy.nvim
  - `lsp/`: LSP configuration with handlers and language-specific settings
  - `colorscheme.lua`: Rose Pine theme configuration with light/dark mode toggle
  - And many more feature-specific modules

## Getting Started 🚀

1. Clone this repository to your Neovim config directory:
   ```
   git clone https://github.com/yourusername/nvim-config ~/.config/nvim
   ```
2. Start Neovim and lazy.nvim will automatically install all plugins
3. Use `:Mason` to install any additional language servers

## Keyboard Shortcuts 🎹

- `<leader>th`: Toggle between light and dark themes
- `<leader>xx`: Toggle diagnostics panel (Trouble)
- `<leader>u`: Find files with Telescope
- `<leader>s`: Live grep with Telescope

## License ⚖️

This Neovim configuration is available under the MIT License. For more details, see the [LICENSE](LICENSE) file.
