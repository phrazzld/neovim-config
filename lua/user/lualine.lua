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

	-- Stylish mode component with custom highlights and icons
	local mode = {
		"mode",
		fmt = function(str)
			return " " .. str .. " "
		end,
		padding = { left = 0, right = 0 },
	}

	-- Enhanced diagnostics with fancy icons and colors
	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn", "info", "hint" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		colored = true,
		update_in_insert = true,
		always_visible = false,
		padding = { left = 1, right = 1 },
	}

	-- Git changes with colorful icons
	local diff = {
		"diff",
		colored = true,
		symbols = { added = " ", modified = " ", removed = " " },
		cond = hide_in_width,
		padding = { left = 1, right = 1 },
	}

	-- Filetype with devicons
	local filetype = {
		"filetype",
		colored = true,
		icon_only = false,
		icon = { align = "right" },
		padding = { left = 1, right = 1 },
	}

	-- Git branch with cooler icon
	local branch = {
		"branch",
		icons_enabled = true,
		icon = "󰘬",
		padding = { left = 1, right = 1 },
		fmt = function(str)
			return str:len() > 20 and str:sub(1, 17) .. "..." or str
		end,
	}

	-- Minimalist location indicator
	local location = {
		"location",
		padding = { left = 1, right = 1 },
		fmt = function(str)
			return " " .. str .. " "
		end,
	}

	-- Fancy filename with better path handling
	local filename = {
		"filename",
		file_status = true,
		path = 1,
		shorting_target = 40,
		symbols = {
			modified = "󰷥 ",
			readonly = "󱀰 ",
			unnamed = "[No Name]",
			newfile = "[New]",
		},
		fmt = function(str)
			local modified = vim.bo.modified and "󰷥 " or ""
			return modified .. str
		end,
	}

	-- Smooth progress bar with gradient animation
	local progress = function()
		local current_line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")

		-- Fancy progress bar characters (gradient style)
		local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

		local line_ratio = current_line / total_lines
		local index = math.ceil(line_ratio * #chars)

		-- Generate a slick progress representation
		local percentage = math.floor(line_ratio * 100)
		if percentage == 0 then
			return "󰦂 TOP"
		elseif percentage == 100 then
			return "󰦃 BOT"
		else
			local result = ""
			for i = 1, 8 do
				if i <= index then
					result = result .. chars[i]
				else
					result = result .. " "
				end
			end
			return result .. " " .. percentage .. "%%"
		end
	end

	-- LSP status indicator
	local lsp_status = {
		function()
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return "󱘎 No LSP"
			end

			local buf_clients = vim.lsp.buf_get_clients()
			if next(buf_clients) == nil then
				return "󱘎 No LSP"
			end

			local buf_client_names = {}
			for _, client in pairs(buf_clients) do
				table.insert(buf_client_names, client.name)
			end

			local unique_client_names = vim.fn.uniq(buf_client_names)
			return " " .. table.concat(unique_client_names, ", ")
		end,
		padding = { left = 1, right = 1 },
		cond = hide_in_width,
	}

	-- Session duration
	local session_time = {
		function()
			return " " .. os.date("%H:%M")
		end,
		padding = { left = 1, right = 1 },
	}

	-- Define a custom theme with slick gradient colors
	local custom_theme = require("lualine.themes.auto")
	local colors = {
		bg = "#1a1b26",
		fg = "#c0caf5",
		yellow = "#e0af68",
		cyan = "#7dcfff",
		green = "#9ece6a",
		orange = "#ff9e64",
		violet = "#bb9af7",
		magenta = "#ff007c",
		blue = "#7aa2f7",
		red = "#f7768e",
	}

	-- Override theme colors for a slick look
	custom_theme.normal.a.bg = colors.blue
	custom_theme.normal.b.bg = colors.bg
	custom_theme.normal.c.bg = colors.bg
	custom_theme.insert.a.bg = colors.green
	custom_theme.visual.a.bg = colors.violet
	custom_theme.replace.a.bg = colors.red
	custom_theme.command.a.bg = colors.yellow

	lualine.setup({
		options = {
			icons_enabled = true,
			theme = custom_theme,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "alpha", "dashboard", "Outline", "markdown", "fzf", "TelescopePrompt" },
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { mode },
			lualine_b = { branch, diff },
			lualine_c = { filename },
			lualine_x = { lsp_status, diagnostics, filetype, "encoding" },
			lualine_y = { session_time },
			lualine_z = { location, progress },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = { location },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = { "fugitive", "nvim-tree", "toggleterm", "trouble" },
	})
end

return M
