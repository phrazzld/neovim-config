vim.opt.termguicolors = true

-- Set the seed for the random number generator
math.randomseed(os.time())

local light_colorschemes = {
	"tokyonight",
	"tokyonight-day",
	"kanagawa",
	"kanagawa-lotus",
	"catppuccin",
	"catppuccin-latte",
	"gruvbox",
	"default",
	"lunaperche",
	"retrobox",
	"shine",
	"wildcharm",
	"dayfox",
	"dawnfox",
	"github_light",
	"github_light_colorblind",
	"github_light_high_contrast",
	"github_light_tritanopia",
	"everforest",
	"oxocarbon",
	"pink-panic",
}

local dark_colorschemes = {
	"tokyonight",
	"tokyonight-moon",
	"tokyonight-night",
	"tokyonight-storm",
	"kanagawa",
	"kanagawa-dragon",
	"kanagawa-wave",
	"catppuccin",
	"catppuccin-frappe",
	"catppuccin-macchiato",
	"catppuccin-mocha",
	"gruvbox",
	"darkblue",
	"habamax",
	"lunaperche",
	"quiet",
	"retrobox",
	"slate",
	"sorbet",
	"wildcharm",
	"zaibatsu",
	"nightfox",
	"duskfox",
	"nordfox",
	"terafox",
	"carbonfox",
	"github_dark",
	"github_dark_colorblind",
	"github_dark_dimmed",
	"github_dark_high_contrast",
	"github_dark_tritanopia",
	"everforest",
	"oxocarbon",
}

-- Function to choose a random colorscheme
local function choose_random_colorscheme(schemes)
	local index = math.random(#schemes)
	return schemes[index]
end

local colorscheme

-- Function to determine whether it's currently day or night
local function is_daytime()
	local hour = os.date("*t").hour
	return hour < 19 and hour > 6
end

if is_daytime() then
	colorscheme = choose_random_colorscheme(light_colorschemes)
else
	colorscheme = choose_random_colorscheme(dark_colorschemes)
end

local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err)
	return
end

if is_daytime() then
	vim.opt.background = "light"
else
	vim.opt.background = "dark"
end
