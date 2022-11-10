vim.opt.termguicolors = true

local colorscheme

-- Use dark mode from 1700 - 0800
local hour = os.date("*t").hour
if hour >= 17 or hour <= 7 then
	colorscheme = "tokyonight"
	vim.opt.background = "dark"
else
	colorscheme = "github_light"
	vim.opt.background = "light"
end

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
