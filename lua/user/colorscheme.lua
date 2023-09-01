vim.opt.termguicolors = true

-- function to determine whether it's currently day or night
local function is_daytime()
	local hour = os.date("*t").hour
	return hour < 19 and hour > 6
end

local colorscheme
if is_daytime() then
	vim.opt.background = "light"
	colorscheme = "github_light"
else
	vim.opt.background = "dark"
	colorscheme = "rose-pine"
end

local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err)
	return
end

-- good light themes
-- - everforest
-- - github_light
-- - kanagawa
-- - lunaperche
-- - wildcharm
