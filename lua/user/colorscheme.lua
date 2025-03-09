-- Enable true color support
vim.opt.termguicolors = true

-- Set the fixed colorscheme
vim.cmd("colorscheme rose-pine")

-- Initialize current theme mode
_G.current_theme_mode = "dark"

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