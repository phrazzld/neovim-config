-- Enable true color support
vim.opt.termguicolors = true

-- Get the current hour (0-23)
local current_hour = os.date("*t").hour

-- Determine theme mode based on time of day
_G.current_theme_mode = (current_hour >= 6 and current_hour < 18) and "light" or "dark"

-- Set background before colorscheme to avoid flicker
vim.opt.background = _G.current_theme_mode

-- Try to set the preferred colorscheme, fall back to a default if not available
local function set_colorscheme(colorscheme_list)
    -- Try each colorscheme in order until one succeeds
    for _, colorscheme in ipairs(colorscheme_list) do
        local ok = pcall(vim.cmd, "colorscheme " .. colorscheme)
        if ok then
            return true
        end
    end
    
    -- If all failed, set a very safe fallback
    vim.cmd("colorscheme default")
    return false
end

-- Try to set colorscheme from a prioritized list
-- These are ordered by preference and guaranteed availability
local colorschemes = {
    "rose-pine",
    "tokyonight",
    "gruvbox",
    "catppuccin",
    "github_dark",
    "default"
}

set_colorscheme(colorschemes)

-- Function to toggle between light and dark themes safely
function ToggleTheme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		
		-- Try to set the colorscheme safely
		pcall(function()
			set_colorscheme(colorschemes)
		end)
		
		vim.notify("Switched to light theme", vim.log.levels.INFO)
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		
		-- Try to set the colorscheme safely
		pcall(function()
			set_colorscheme(colorschemes)
		end)
		
		vim.notify("Switched to dark theme", vim.log.levels.INFO)
	end
end

-- Bind the ToggleTheme function to <leader>th
vim.keymap.set("n", "<leader>th", ToggleTheme, { noremap = true, silent = true, desc = "Toggle light/dark theme" })