local M = {}

M.setup = function()
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return
	end

	require("incline").setup({
		hide = {
			cursorline = false,
			focused_win = false,
			only_win = false,
		},
		ignore = {
			buftypes = "special",
			filetypes = { "markdown" },
			floating_wins = true,
			unlisted_buffers = true,
			wintypes = "special",
		},
	})

	local hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end

	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		colored = false,
		update_in_insert = false,
		always_visible = false,
	}

	local diff = {
		"diff",
		colored = false,
		symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
		cond = hide_in_width,
	}

	local filetype = {
		"filetype",
		colored = false,
		icon_only = false,
		icon = { align = "right" },
	}

	local branch = {
		"branch",
		icons_enabled = true,
		icon = "",
	}

	local location = {
		"location",
		padding = 0,
	}

	local filename = {
		"filename",
		file_status = true,
		path = 1,
		cond = hide_in_width,
		shorting_target = 40,
	}

	local progress = function()
		local current_line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")
		local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
		local line_ratio = current_line / total_lines
		local index = math.ceil(line_ratio * #chars)
		return chars[index]
	end

	lualine.setup({
		options = {
			icons_enabled = true,
			theme = "rose-pine",
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "alpha", "dashboard", "Outline", "markdown", "fzf", "TelescopePrompt" },
			always_divide_middle = false,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { filename },
			lualine_c = { branch, diff },
			lualine_x = { "encoding", filetype },
			lualine_y = { diagnostics },
			lualine_z = { location, progress },
		},
		extensions = { "fugitive", "nvim-tree", "toggleterm", "trouble" },
	})
end

return M