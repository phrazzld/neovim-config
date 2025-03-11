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

## Development Principles

### Commits
- **Conventional Commits**: Use structured messages (`feat:`, `fix:`, `docs:`, `chore:`)
- **Atomic Changes**: Each commit should contain exactly one logical change

### Logging & Observability
- Implement structured logging where applicable
- Include detailed logs during development for easier troubleshooting

### Architecture & Design
- **Modularity**: Embrace loose coupling for maintainability
- **Error Handling**: Prioritize explicit error handling with meaningful messages
- **Separation of Concerns**: Keep business logic separate from infrastructure

### Documentation
- Document the **why** behind design decisions
- Keep documentation close to the code in markdown format
- Update documentation as part of completing any change

### Performance & Security
- Establish performance baselines for critical operations
- Assume all inputs could be hostile; build with secure defaults
- Regularly scan dependencies for vulnerabilities

### Continuous Improvement
- Regularly review code for improvement opportunities
- Treat technical debt as real debt—actively manage and reduce it
- Foster a culture that values learning from controlled failures