# Neovim — Markdown Writing Kit

Fast, clean, gorgeous. Raw markdown only.

## Stack

| Plugin | Role |
|--------|------|
| **ember** | Warm Ember theme (system-aware dark/light), toggle `<leader>th` |
| **goyo.vim** | Distraction-free centered writing, **auto-enters** on markdown |
| **markdown.nvim** | Heading nav `]]`/`[[`, checkbox, table format |
| **oil.nvim** | File browser `<leader>e` |
| **telescope** | Find files / live grep |
| **hop.nvim** | Jump by word/line |
| **nvim-surround** | `**bold**`, `` `code` ``, links |
| **treesitter** | Markdown + frontmatter + syntax highlights |

Raw markdown with Omawrite/iA Writer typographic polish. No conceal. No newline glyphs. No LSP.

## Theme

- Default: **ember dawn** (light) / **ember ink** (dark)
- System-aware: detects Omarchy theme (`colors.toml`) or macOS appearance (`defaults read -g AppleInterfaceStyle`), fallback `light`
- Polished dark mode: warm charcoal background (`#16141d`), parchment text (`#e6dfd5`), glowing amber/gold accents
- Typographic hierarchy: heading scale (H1 amber -> H6 rose), dimmed syntax markers (`#`, `*`, `>`) so prose stands out, subtle code background pills
- Toggle: `<leader>th`
## Keybindings

| Key | Action |
|-----|--------|
| `<leader>z` / `<leader>gy` | Goyo toggle (distraction-free) |
| `<leader>th` | Toggle dark/light theme |
| `<leader>tw` | Toggle typewriter mode (centered cursor) |
| `<leader>ms` | Show document stats (word count, reading time) |
| `<leader>fy` | Toggle YAML frontmatter fold (`:MDFrontmatter`) |
| `<leader>ff` / `<leader><leader>` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>e` | Oil file browser |
| `]]` / `[[` | Next / prev heading |
| `<leader>x` / `<leader>mt` | Toggle checkbox (`[ ]` <-> `[x]`) |
| `<leader>mf` | Format markdown table |
| `<leader>mk` | Insert link / wrap selection (auto-pastes clipboard URL) |
| `<leader>o` / `<leader>l` | Hop word / line |
| `j` / `k` | Wrapped-line motion |
| `<CR>` (insert) | Smart list continuation (auto-numbers `1.`, exits on empty item) |
| `<leader>w` / `<leader>q` | Write / quit |

## Behavior

- Opens markdown -> auto Goyo (80 cols, centered, seamless background, no line numbers)
- Raw view: `conceallevel=0`, `showbreak=""`, `list=false` — clean raw text
- YAML frontmatter folds closed on open so writing starts at the title. `<leader>fy` toggles it from anywhere; `za` only works on the fold line. File stays raw (no conceal)
- Word count and cursor position in minimal statusline
- Smart return in lists: pressing `<CR>` continues `- `, `* `, `1. `, or `> `; pressing `<CR>` on an empty item clears the bullet cleanly
- Table formatting (`:MDTableFormat` / `<leader>mf`) preserves GFM-style escaped pipes (`\|`) inside cells, including code spans. Bare pipes remain cell separators.

## Tests

Run the table formatter regression tests from the repository root with Neovim:

```sh
nvim --headless -u NONE -i NONE -l tests/table.lua
```

The tests use synthetic scratch buffers without loading your config or plugins.

## Layout

```
init.lua
lua/user/
  options.lua
  keymaps.lua
  plugins.lua
after/ftplugin/markdown.lua
```
