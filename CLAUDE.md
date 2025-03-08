# Neovim Configuration Guidelines

## Commands
- **Format/Lint**: Handled by LSP/null-ls (automatic)
- **Test**: Tests run through specific language commands (e.g., `go test`)
- **LSP**: Mason manages LSPs - `:Mason` to install/manage servers

## Style Guidelines
- **Lua Format**: Indent with tabs, max line length ~100 chars
- **Imports**: Group by category (core vim, then plugins)
- **Error Handling**: Use `pcall` for safe requiring of modules
- **Naming**: Use `snake_case` for variables/functions
- **Module Structure**: One feature per file in `lua/user/` directory
- **Plugin Config**: Use lazy.nvim spec format with explicit dependencies
- **Keymappings**: Use `vim.keymap.set()` with `{noremap=true, silent=true}`
- **Colors**: Theme switching via `<leader>th` between light/dark modes

## Repository Organization
- `init.lua`: Main entry point, requires all modules
- `lua/user/`: Contains all configuration modules by feature