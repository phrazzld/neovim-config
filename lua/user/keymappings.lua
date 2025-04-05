local M = {}

function M.setup()
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
	keymap("n", "<S-l>", "<CMD>bnext<CR>", opts)
	keymap("n", "<S-h>", "<CMD>bprevious<CR>", opts)
	keymap("n", "<C-b>d", "<CMD>bp|bd #<CR>", opts)

	-- split pane navigation
	keymap("n", "<C-j>", "<C-w>j", opts)
	keymap("n", "<C-h>", "<C-w>h", opts)
	keymap("n", "<C-k>", "<C-w>k", opts)
	keymap("n", "<C-l>", "<C-w>l", opts)

	-- file tree
	keymap("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", opts)

	-- move text up and down
	-- ∆ = alt+j
	-- ˚ = alt+k
	keymap("v", "∆", "<CMD>m .+1<CR>==", opts)
	keymap("v", "˚", "<CMD>m .-2<CR>==", opts)
	keymap("x", "∆", "<CMD>move '>+1<CR>gv-gv", opts)
	keymap("x", "˚", "<CMD>move '<-2<CR>gv-gv", opts)
	keymap("n", "∆", "<CMD>m .+1<CR>==", opts)
	keymap("n", "˚", "<CMD>m .-2<CR>==", opts)

	-- Telescope
	keymap(
		"n",
		"<leader>u",
		"<CMD>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
		opts
	)
	keymap("n", "<leader>s", "<cmd>Telescope live_grep<CR>", opts)

	-- formatting
	keymap("n", "<C-f>f", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", opts)

	-- hop
	keymap("n", "<leader>o", "<CMD>HopWord<CR>", opts)
	keymap("n", "<leader>l", "<CMD>HopLine<CR>", opts)

	-- git
	keymap("n", "<leader>gs", "<CMD>Git status<CR>", opts)
	keymap("n", "<leader>ga", "<CMD>Git add -p .<CR>", opts)
	keymap("n", "<leader>gc", "<CMD>Git commit<CR>", opts)
	keymap("n", "<leader>gp", "<CMD>Git push<CR>", opts)

	-- trouble
	keymap("n", "<leader>tx", "<CMD>Trouble<CR>", opts)
	keymap("n", "<leader>tt", "<CMD>TodoTrouble<CR>", opts)
	keymap("n", "<leader>td", "<CMD>TroubleToggle document_diagnostics<CR>", opts)
	keymap("n", "<leader>tw", "<CMD>TroubleToggle workspace_diagnostics<CR>", opts)

	-- goyo (distraction-free writing)
	keymap("n", "<leader>gy", "<CMD>Goyo<CR>", opts)

	-- typescript tools
	keymap("n", "<leader>to", "<CMD>TSToolsOrganizeImports<CR>", opts)
	keymap("n", "<leader>ta", "<CMD>TSToolsAddMissingImports<CR>", opts)
	-- Add debug commands for TypeScript
	keymap("n", "<leader>tl", "<CMD>LspInfo<CR>", opts)
end

return M
