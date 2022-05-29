local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Make space the leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes reference
--   normal_mode       = "n"
--   insert_mode       = "i",
--   visual_mode       = "v",
--   visual_block_mode = "x",
--   term_mode         = "t",
--   command_mode      = "c"

-- buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- split pane navigation
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- file tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- move text up and down
-- ∆ = alt+j
-- ˚ = alt+k
keymap("v", "∆", ":m .+1<CR>==", opts)
keymap("v", "˚", ":m .-2<CR>==", opts)
keymap("x", "∆", ":move '>+1<CR>gv-gv", opts)
keymap("x", "˚", ":move '<-2<CR>gv-gv", opts)

-- Telescope
keymap(
  "n",
  "<leader>f",
  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
  opts
)
--keymap('n', '<leader>f', "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<CR>", opts)
--keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
--keymap('n', '<leader>ft', '<cmd>Telescope git_branches<CR>', opts)

-- formatting
keymap("n", "<leader>m", ":Format<CR>", opts)

-- hop
keymap("n", "<leader>o", ":HopWord<CR>", opts)
keymap("n", "<leader>l", ":HopLine<CR>", opts)

-- git
keymap("n", "<C-g>s", ":Git status<CR>", opts)
keymap("n", "<C-g>a", ":Git add -p .<CR>", opts)
keymap("n", "<C-g>c", ":Git commit<CR>", opts)
keymap("n", "<C-g>h", ":Git push<CR>", opts)
