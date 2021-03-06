-- format go code before save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  command = [[ :silent! lua require('go.format').gofmt() ]]
})

-- better formatting for text editing
-- markdown files
-- NOTE: vim doesn't know *.md files are markdown files
-- so we have to use VimEnter on the glob pattern
-- instead of FileType = markdown
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*.md",
  command = "setlocal wrap linebreak nolist cursorline!"
})
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*.md",
  command = "nnoremap j gj"
})
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*.md",
  command = "nnoremap k gk"
})
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*.md",
  command = "Goyo"
})

-- text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  command = "setlocal wrap linebreak nolist cursorline!"
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  command = "nnoremap j gj"
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  command = "nnoremap k gk"
})

-- remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
