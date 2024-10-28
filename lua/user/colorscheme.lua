-- Enable true color support
vim.opt.termguicolors = true

-- Seed the random number generator
math.randomseed(os.time())

-- Define dark and light color schemes
local dark_colorschemes = {
	"catppuccin",
	"catppuccin-frappe",
	"everforest",
	"rose-pine",
	"tokyonight",
	"kanagawa",
	"github_dark",
	"nightfox",
}

local light_colorschemes = {
	"catppuccin-latte",
	"everforest",
	"rose-pine-dawn",
	"tokyonight-day",
	"kanagawa-lotus",
	"github_light",
}

-- Set initial background to dark
vim.opt.background = "dark"

-- Initialize current theme mode
_G.current_theme_mode = "dark"

-- Function to toggle between light and dark themes
function ToggleTheme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		-- Select a random light theme
		local colorscheme = light_colorschemes[math.random(#light_colorschemes)]
		-- Apply the colorscheme safely
		local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
		if not ok then
			vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
		else
			vim.notify("Switched to light theme: " .. colorscheme, vim.log.levels.INFO)
		end
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		-- Select a random dark theme
		local colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]
		-- Apply the colorscheme safely
		local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
		if not ok then
			vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
		else
			vim.notify("Switched to dark theme: " .. colorscheme, vim.log.levels.INFO)
		end
	end
end

-- Bind the ToggleTheme function to <leader>th
vim.api.nvim_set_keymap("n", "<leader>th", ":lua ToggleTheme()<CR>", { noremap = true, silent = true })

-- Apply an initial colorscheme
local initial_colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]
local ok, err = pcall(vim.cmd, "colorscheme " .. initial_colorscheme)
if not ok then
	vim.notify("Failed to load the colorscheme '" .. initial_colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
end
