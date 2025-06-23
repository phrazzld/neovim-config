# Neovim Configuration

My modern, modular Neovim setup optimized for performance, productivity, and aesthetics. Built entirely in Lua with the elegant Rose Pine colorscheme.

## Core Features

- **Performance-Optimized**: Lazy-loading plugins and deferred initialization for <100ms startup
- **Rose Pine Theme**: Clean, minimal aesthetic with light/dark mode toggle
- **Modern LSP Experience**: Intelligent code completion, diagnostics, and navigation
- **AI-Powered Assistant**: Inline LLM integration with local Ollama for code explanation and assistance
- **TypeScript Power Tools**: First-class support for TS/TSX with typescript-tools.nvim
- **Git Integration**: Seamless workflow with gitsigns and fugitive
- **Distraction-Free Writing**: Markdown support with Goyo
- **Robust Error Handling**: Prevention of LSP semantic tokens errors in TypeScript files

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

## LLM Configuration

The AI-powered assistant requires [Ollama](https://ollama.ai) for local LLM inference.

### Prerequisites

1. **Install Ollama**: Download from [ollama.ai](https://ollama.ai) or use package manager
   ```bash
   # macOS
   brew install ollama
   
   # Linux
   curl -fsSL https://ollama.ai/install.sh | sh
   ```

2. **Pull a model**: Download your preferred model
   ```bash
   ollama pull gemma3:4b        # Default model (4B parameters)
   ollama pull llama3.2:3b      # Alternative: smaller, faster
   ollama pull codellama:7b     # Alternative: code-specialized
   ```

3. **Start Ollama**: Ensure the service is running
   ```bash
   ollama serve  # Or start the Ollama app
   ```

### Configuration Options

The LLM plugin works out-of-the-box with sensible defaults. To customize, add this to your `init.lua`:

```lua
-- Default configuration (no setup needed)
require("user.llm").setup()

-- Custom configuration example
require("user.llm").setup({
  model = "llama3.2:3b",        -- Model name (default: "gemma3:4b")
  url = "http://localhost:11434", -- Ollama URL (default: "http://localhost:11434")
  timeout = 60000,              -- Timeout in ms (default: 30000)
  keymap = "<leader>ai"         -- Visual mode keymap (default: "<leader>ll")
})
```

### Configuration Examples

**Fast responses (smaller model)**:
```lua
require("user.llm").setup({
  model = "llama3.2:3b",
  timeout = 15000  -- 15 seconds
})
```

**Code-specialized model**:
```lua
require("user.llm").setup({
  model = "codellama:7b",
  timeout = 45000  -- 45 seconds for larger model
})
```

**Remote Ollama server**:
```lua
require("user.llm").setup({
  url = "http://192.168.1.100:11434",
  timeout = 60000  -- Higher timeout for network requests
})
```

### Usage

1. Select text in visual mode (`v`, `V`, or `<C-v>`)
2. Press `<leader>ll` (or your custom keymap)
3. Wait for the blockquoted response to appear

### Troubleshooting

- **"curl not found"**: Install curl via your package manager
- **Connection errors**: Ensure Ollama is running (`ollama serve`)
- **Model errors**: Pull the model first (`ollama pull modelname`)
- **Timeouts**: Increase timeout for complex queries or larger models

## Useful Keybindings

| Key           | Action                      |
|---------------|----------------------------|
| `<leader>th`  | Toggle light/dark theme    |
| `<leader>u`   | Find files (Telescope)     |
| `<leader>s`   | Search in files (Telescope)|
| `<leader>ll`  | Query LLM with selection   |
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
