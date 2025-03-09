-- Enable true color support
vim.opt.termguicolors = true

-- Get the current hour (0-23)
local current_hour = os.date("*t").hour

-- Determine theme mode based on time of day
_G.current_theme_mode = (current_hour >= 6 and current_hour < 18) and "light" or "dark"

-- Set background before colorscheme to avoid flicker
vim.opt.background = _G.current_theme_mode

-- Set the fixed colorscheme
vim.cmd("colorscheme rose-pine")

-- Function to toggle between light and dark themes
function ToggleTheme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		vim.notify("Switched to light theme", vim.log.levels.INFO)
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		vim.notify("Switched to dark theme", vim.log.levels.INFO)
	end
end

-- Bind the ToggleTheme function to <leader>th
vim.api.nvim_set_keymap("n", "<leader>th", ":lua ToggleTheme()<CR>", { noremap = true, silent = true })