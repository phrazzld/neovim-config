local M = {}

function M.setup()
	local options = {
		backup = false,
		cmdheight = 2,
		completeopt = { "menuone", "noselect" },
		pumheight = 10,
		timeoutlen = 1000,
		updatetime = 300,
		writebackup = false,
		hidden = true,
		scrolloff = 8,
		sidescrolloff = 8,
		splitbelow = true,
		splitright = true,
		visualbell = true,
		incsearch = true,
		hlsearch = false,
		expandtab = true,
		swapfile = false,
		number = true,
		relativenumber = true,
		wrap = false,
		cursorline = true,
		showmode = false,
		signcolumn = "yes",
		tabstop = 2,
		shiftwidth = 2,
		autoindent = true,
		smartindent = true,
		laststatus = 3,
		-- Disable folding completely
		foldenable = false,
		foldmethod = "manual",
		foldlevelstart = 99,
	}

	for k, v in pairs(options) do
		vim.opt[k] = v
	end
end

return M