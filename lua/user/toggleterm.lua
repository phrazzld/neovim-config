local M = {}

M.setup = function()
	local ok, toggleterm = pcall(require, "toggleterm")
	if not ok then
		vim.notify("failed to load toggleterm")
		return
	end

	toggleterm.setup({
		size = 20,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 0,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
	})

	function _G.set_terminal_keymaps()
		local opts = { noremap = true }
		vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
	end

	-- Use the modern API for autocommands
	local term_group = vim.api.nvim_create_augroup("TerminalKeymaps", { clear = true })
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "term://*",
		callback = function()
			_G.set_terminal_keymaps()
		end,
		group = term_group,
	})

	-- Safely initialize Terminal applications
	local term_ok, term_module = pcall(require, "toggleterm.terminal")
	if not term_ok then
		vim.notify("Failed to load toggleterm terminal module", vim.log.levels.WARN)
		return
	end

	local Terminal = term_module.Terminal

	-- Helper function to create terminal toggles safely
	local function create_terminal_toggle(name, cmd)
		local terminal = Terminal:new({ cmd = cmd, hidden = true })
		_G["_" .. name:upper() .. "_TOGGLE"] = function()
			pcall(function()
				terminal:toggle()
			end)
		end
	end

	-- Create all terminal toggles
	create_terminal_toggle("lazygit", "lazygit")
	create_terminal_toggle("node", "node")
	create_terminal_toggle("irb", "irb")
	create_terminal_toggle("ncdu", "ncdu")
	create_terminal_toggle("htop", "htop")
	create_terminal_toggle("python", "python")
end

return M
