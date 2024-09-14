vim.opt.termguicolors = true

-- Seed the random generator
math.randomseed(os.time())

local dark_colorschemes = {
	"catppuccin",
	"catppuccin-frappe",
	"everforest",
	"rose-pine",
	"tokyonight",
	"gruvbox",
	"kanagawa",
	"github_dark",
	"nightfox",
	"habamax",
	"oxocarbon",
	"retrobox",
}

vim.opt.background = "dark"
local colorscheme = dark_colorschemes[math.random(#dark_colorschemes)]

local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err, vim.log.levels.ERROR)
	return
end
