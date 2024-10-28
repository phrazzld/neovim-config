-- Enable true color support
vim.opt.termguicolors = true

-- Seed the random number generator for theme selection
math.randomseed(os.time())

-- Define dark color schemes
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

-- Define light color schemes
local light_colorschemes = {
	"catppuccin",
	"dawnfox",
	"everforest",
	"rose-pine",
	"kanagawa",
	"github_light",
	"gruvbox",
}

-- Get the current hour (0-23)
local current_hour = os.date("*t").hour

-- Determine INITIAL_COLORSCHEME based on time of day
local INITIAL_COLORSCHEME
if current_hour >= 6 and current_hour < 18 then
	INITIAL_COLORSCHEME = "light"
else
	INITIAL_COLORSCHEME = "dark"
end

-- Set initial background based on INITIAL_COLORSCHEME
vim.opt.background = INITIAL_COLORSCHEME

-- Initialize current theme mode
_G.current_theme_mode = INITIAL_COLORSCHEME

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

-- Apply an initial colorscheme based on INITIAL_COLORSCHEME
local initial_colorscheme
if _G.current_theme_mode == "dark" then
	-- Select a random dark theme
	initial_colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]
else
	-- Select a random light theme
	initial_colorscheme = light_colorschemes[math.random(#light_colorschemes)]
end

-- Apply the initial colorscheme safely
local ok, err = pcall(vim.cmd, "colorscheme " .. initial_colorscheme)
if not ok then
	vim.notify("Failed to load the colorscheme '" .. initial_colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
end
