vim.opt.termguicolors = true

local colorscheme

-- Use dark mode from 1800 - 0700
local hour = os.date("*t").hour
if hour >= 19 or hour <= 6 then
	--colorscheme = "tokyonight"
	vim.opt.background = "dark"
else
	--colorscheme = "github_light"
	vim.opt.background = "light"
end

-- colorscheme = "slate"
-- colorscheme = "gruvbox"
colorscheme = "tokyonight"
-- colorscheme = "kanagawa"
-- colorscheme = "catppuccin"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
