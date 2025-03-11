local M = {}

M.setup = function()
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return
	end

	-- Disable incline.nvim since we're now showing full paths in lualine
	-- and it was blocking text underneath
	-- require("incline").setup({
	-- 	hide = {
	-- 		cursorline = false,
	-- 		focused_win = false,
	-- 		only_win = false,
	-- 	},
	-- 	ignore = {
	-- 		buftypes = "special",
	-- 		filetypes = { "markdown" },
	-- 		floating_wins = true,
	-- 		unlisted_buffers = true,
	-- 		wintypes = "special",
	-- 	},
	-- })

	local hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end

	-- Define colors for our bubble theme
	local colors = {
		bg = "#1a1b26",
		fg = "#c0caf5",
		black = "#414868",
		yellow = "#e0af68",
		cyan = "#7dcfff",
		green = "#9ece6a",
		orange = "#ff9e64",
		magenta = "#bb9af7",
		purple = "#9d7cd8",
		pink = "#ff007c",
		blue = "#7aa2f7",
		red = "#f7768e",
		gray = "#24283b",
		darkgray = "#1f2335",
		lightgray = "#545c7e",
	}

	-- Create a custom bubble theme
	local bubble_theme = {
		normal = {
			a = { fg = colors.black, bg = colors.blue, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.blue, gui = "bold" },
		},
		insert = {
			a = { fg = colors.black, bg = colors.green, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.green, gui = "bold" },
		},
		visual = {
			a = { fg = colors.black, bg = colors.magenta, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.magenta, gui = "bold" },
		},
		replace = {
			a = { fg = colors.black, bg = colors.red, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.red, gui = "bold" },
		},
		command = {
			a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.yellow, gui = "bold" },
		},
		terminal = {
			a = { fg = colors.black, bg = colors.cyan, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
			z = { fg = colors.black, bg = colors.cyan, gui = "bold" },
		},
		inactive = {
			a = { fg = colors.lightgray, bg = colors.darkgray },
			b = { fg = colors.lightgray, bg = colors.darkgray },
			c = { fg = colors.lightgray, bg = colors.darkgray },
		},
	}

	-- Mode component with cool icons
	local mode = {
		function()
			local mode_map = {
				n = { icon = "󰋜", name = "NORMAL" },
				i = { icon = "󰏫", name = "INSERT" },
				v = { icon = "󰒉", name = "VISUAL" },
				V = { icon = "󰒋", name = "V-LINE" },
				[""] = { icon = "󰧂", name = "V-BLOCK" }, -- ctrl+v
				R = { icon = "󰊄", name = "REPLACE" },
				c = { icon = "󰞷", name = "COMMAND" },
				t = { icon = "󰆍", name = "TERMINAL" },
			}

			local current = vim.fn.mode()
			local mode_data = mode_map[current] or { icon = "󰋜", name = string.upper(current) }
			return " " .. mode_data.icon .. " " .. mode_data.name .. " "
		end,
	}

	-- Enhanced diagnostics with fancy icons and colors
	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn", "info", "hint" },
		symbols = {
			error = " ",
			warn = " ",
			info = " ",
			hint = "󰌵 ",
		},
		colored = true,
		update_in_insert = true,
		always_visible = false,
		padding = { left = 1, right = 1 },
	}

	-- Git changes with colorful icons
	local diff = {
		"diff",
		colored = true,
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.orange },
			removed = { fg = colors.red },
		},
		symbols = {
			added = " ",
			modified = " ",
			removed = " ",
		},
		cond = hide_in_width,
		padding = { left = 1, right = 1 },
	}

	-- Filetype with devicons
	local filetype = {
		"filetype",
		colored = true,
		icon_only = false,
		padding = { left = 1, right = 1 },
	}

	-- Git branch with cooler icon
	local branch = {
		"branch",
		icons_enabled = true,
		icon = "󱓋 ",
		padding = { left = 1, right = 1 },
		fmt = function(str)
			if str == "" then
				return "󱓎 No Branch"
			end
			return str:len() > 20 and str:sub(1, 17) .. "..." or str
		end,
	}

	-- Minimalist location indicator
	local location = {
		function()
			local line = vim.fn.line(".")
			local col = vim.fn.virtcol(".")
			return string.format(" 󰍒 %d:%d ", line, col)
		end,
	}

	-- Fancy filename with FULL path handling
	local filename = {
		"filename",
		file_status = true,
		newfile_status = true,
		path = 3, -- Show full path (changed from 1 to 3)
		shorting_target = 80, -- Increased from 40 to 80
		symbols = {
			modified = "󰷥 ",
			readonly = "󱀰 ",
			unnamed = "󱀫 No Name",
			newfile = "󰟒 New",
		},
		fmt = function(str)
			local modified = vim.bo.modified and "󰷥 " or ""
			return "󰈔 " .. modified .. str
		end,
	}

	-- Smooth progress bar with gradient animation
	local progress = {
		function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")

			-- Get percentage through file
			local line_ratio = current_line / total_lines
			local percentage = math.floor(line_ratio * 100)

			-- Special cases for top/bottom
			if percentage == 0 then
				return " 󰦂 TOP "
			elseif percentage == 100 then
				return " 󰦃 BOT "
			else
				-- Determine icon based on percentage
				local icons = { "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }
				local icon_index = math.ceil(line_ratio * #icons)
				if icon_index < 1 then
					icon_index = 1
				end
				if icon_index > #icons then
					icon_index = #icons
				end
				local icon = icons[icon_index]
				return " " .. icon .. " " .. percentage .. "%% "
			end
		end,
	}

	-- Fancy LSP status indicator
	local lsp_status = {
		function()
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return "󱘎 No LSP"
			end

			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(buf_clients) == nil then
				return "󱘎 No LSP"
			end

			local buf_client_names = {}
			for _, client in pairs(buf_clients) do
				table.insert(buf_client_names, client.name)
			end

			local unique_client_names = vim.fn.uniq(buf_client_names)
			local count = #unique_client_names

			-- Use different icons based on LSP count
			local lsp_icon = "󰄭"
			if count > 2 then
				lsp_icon = "󰏫"
			elseif count > 1 then
				lsp_icon = "󱘖"
			end

			-- Ensure we have a table to concat
			if type(unique_client_names) ~= "table" or count == 0 then
				return lsp_icon .. " No LSP"
			end

			return lsp_icon .. " " .. table.concat(unique_client_names, ", ")
		end,
		padding = { left = 1, right = 1 },
		cond = hide_in_width,
	}

	-- Clock with fancy icon
	local clock = {
		function()
			return "󰥔 " .. os.date("%H:%M")
		end,
		padding = { left = 1, right = 1 },
	}

	-- File encoding with icon
	local encoding = {
		"encoding",
		fmt = function(str)
			if str == "" or str == "utf-8" then
				return "󰈡 UTF-8"
			end
			return "󰈡 " .. string.upper(str)
		end,
		padding = { left = 1, right = 1 },
		cond = hide_in_width,
	}

	-- File format indicator with icon
	local fileformat = {
		"fileformat",
		fmt = function(str)
			local map = {
				unix = "󰣇 LF",
				dos = "󰪫 CRLF",
				mac = "󰘦 CR",
			}
			return map[str] or str
		end,
		padding = { left = 1, right = 1 },
		cond = hide_in_width,
	}

	-- File size with fancy formatting
	local filesize = {
		function()
			local function format_file_size(size)
				local units = { "B", "KB", "MB", "GB" }
				local unit_index = 1
				while size > 1024 and unit_index < #units do
					size = size / 1024
					unit_index = unit_index + 1
				end
				return string.format("%.1f %s", size, units[unit_index])
			end

			local size = vim.fn.getfsize(vim.fn.expand("%:p"))
			if size <= 0 then
				return ""
			end
			return "󰛫 " .. format_file_size(size)
		end,
		padding = { left = 1, right = 1 },
		cond = hide_in_width,
	}

	-- Setup lualine with our fancy bubble components
	lualine.setup({
		options = {
			icons_enabled = true,
			theme = bubble_theme,
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
			lualine_b = { filename }, -- moved filename to section B for more prominence
			lualine_c = { branch, diff }, -- moved these to section C
			lualine_x = { filesize, filetype }, -- removed encoding and fileformat to save space
			lualine_y = { diagnostics, lsp_status }, -- removed clock to save space
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
