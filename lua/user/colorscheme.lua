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
	"morning",
	"peachpuff",
	"quiet",
	"retrobox",
	"shine",
	"wildcharm",
	"zellner",
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
	"catppuccin-machiatto",
	"catppuccin-mocha",
	"gruvbox",
	"tokyodark",
	"darkblue",
	"desert",
	"evening",
	"habamax",
	"lunaperche",
	"murphy",
	"quiet",
	"retrobox",
	"ron",
	"slate",
	"sorbet",
	"torte",
	"wildcharm",
	"zaibatsu",
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
	vim.opt.background = "light"
else
	colorscheme = choose_random_colorscheme(dark_colorschemes)
	vim.opt.background = "dark"
end

-- Apply the colorscheme
local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err)
	return
end
