local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Make space the leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes reference
--   normal_mode       = "n"
--   insert_mode       = "i",
--   visual_mode       = "v",
--   visual_block_mode = "x",
--   term_mode         = "t",
--   command_mode      = "c"

-- buffer navigation
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)

-- split pane navigation
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- file tree
keymap('n', '<leader>e', ':Lex 30<CR>', opts)

-- move text up and down
-- ∆ = alt+j
-- ˚ = alt+k
keymap('v', '∆', ':m .+1<CR>==', opts)
keymap('v', '˚', ':m .-2<CR>==', opts)
keymap('x', 'j', ":move '>+1<CR>gv-gv", opts)
keymap('x', 'k', ":move '<-2<CR>gv-gv", opts)
keymap('x', '∆', ":move '>+1<CR>gv-gv", opts)
keymap('x', '˚', ":move '<-2<CR>gv-gv", opts)
