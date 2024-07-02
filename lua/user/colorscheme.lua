--vim.opt.termguicolors = true

vim.opt.termguicolors = true

-- Seed the random generator
math.randomseed(os.time())

-- Arrays of color schemes for light and dark modes
local light_colorschemes = {
	"everforest",
	"github_light",
	"kanagawa",
	--[[ "lunaperche", ]]
	--[[ "wildcharm", ]]
	"rose-pine",
	--[[ "tokyonight-day", ]]
	--[[ "dayfox", ]]
	"gruvbox",
}
local dark_colorschemes = { "rose-pine", "tokyonight", "gruvbox", "kanagawa", "github_dark", "nightfox" }

-- function to determine whether it's currently day or night
local function is_daytime()
	local hour = os.date("*t").hour
	return hour < 19 and hour > 6
end

local colorscheme

if is_daytime() then
	vim.opt.background = "light"
	-- Select a random light colorscheme
	colorscheme = light_colorschemes[math.random(#light_colorschemes)]
else
	vim.opt.background = "dark"
	-- Select a random dark colorscheme
	colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]
end

--vim.opt.background = "dark"
--local colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]

local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
	return
end
