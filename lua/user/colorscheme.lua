-- Enable true color support
vim.opt.termguicolors = true

-- Get the current hour (0-23)
local current_hour = os.date("*t").hour

-- Determine theme mode based on time of day
_G.current_theme_mode = (current_hour >= 6 and current_hour < 18) and "light" or "dark"

-- Set background before colorscheme to avoid flicker
vim.opt.background = _G.current_theme_mode

-- Set the colorscheme to rose-pine
local function set_colorscheme()
    -- Try to set rose-pine with current mode
    local ok, _ = pcall(vim.cmd, "colorscheme rose-pine")
    
    if not ok then
        -- If rose-pine fails, fall back to default
        vim.cmd("colorscheme default")
        return false
    end
    
    return true
end

set_colorscheme()

-- Function to toggle between light and dark themes safely
function ToggleTheme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		
		-- Set the colorscheme
		pcall(function()
			set_colorscheme()
		end)
		
		vim.notify("Switched to light theme", vim.log.levels.INFO)
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		
		-- Set the colorscheme
		pcall(function()
			set_colorscheme()
		end)
		
		vim.notify("Switched to dark theme", vim.log.levels.INFO)
	end
end

-- Bind the ToggleTheme function to <leader>th
vim.keymap.set("n", "<leader>th", ToggleTheme, { noremap = true, silent = true, desc = "Toggle light/dark theme" })