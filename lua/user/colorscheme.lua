vim.opt.termguicolors = true

-- Set the seed for the random number generator
math.randomseed(os.time())

local colorschemes = {"tokyonight", "kanagawa", "catppuccin"}

-- Function to choose a random colorscheme
local function choose_random_colorscheme(schemes)
	local index = math.random(#schemes)
	return schemes[index]
end

local colorscheme = choose_random_colorscheme(colorschemes)

-- Function to determine whether it's currently day or night
local function is_daytime()
	local hour = os.date("*t").hour
	return hour < 19 and hour > 6
end

if is_daytime() then
	vim.opt.background = "light"
else
	vim.opt.background = "dark"
end

-- Apply the colorscheme
local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err)
	return
end
