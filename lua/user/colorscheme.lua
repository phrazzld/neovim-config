local M = {}

function M.setup()
	-- Enable true color support
	vim.opt.termguicolors = true

	-- Get the current hour (0-23)
	local current_hour = os.date("*t").hour

	-- Determine theme mode based on time of day
	_G.current_theme_mode = (current_hour >= 6 and current_hour < 18) and "light" or "dark"

	-- Set background before colorscheme to avoid flicker
	vim.opt.background = _G.current_theme_mode

	-- Apply the colorscheme
	M.apply_colorscheme()

	-- Set up theme toggle keybinding
	M.setup_toggle_keybind()
end

-- Set the colorscheme to rose-pine
function M.apply_colorscheme()
	-- Try to set rose-pine with current mode
	local ok, _ = pcall(vim.cmd, "colorscheme rose-pine")
	
	if not ok then
		-- If rose-pine fails, fall back to default
		vim.cmd("colorscheme default")
		return false
	end
	
	return true
end

-- Function to toggle between light and dark themes safely
function M.toggle_theme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		
		-- Set the colorscheme
		pcall(function()
			M.apply_colorscheme()
		end)
		
		vim.notify("Switched to light theme", vim.log.levels.INFO)
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		
		-- Set the colorscheme
		pcall(function()
			M.apply_colorscheme()
		end)
		
		vim.notify("Switched to dark theme", vim.log.levels.INFO)
	end
end

-- Setup theme toggle keybinding
function M.setup_toggle_keybind()
	-- Bind the toggle function to <leader>th
	vim.keymap.set("n", "<leader>th", M.toggle_theme, { noremap = true, silent = true, desc = "Toggle light/dark theme" })
end

return M