vim.opt.termguicolors = true

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

local colorscheme = "rose-pine"

local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
	vim.notify("Failed to load the colorscheme '" .. colorscheme .. "'. Error: " .. err)
	return
end
