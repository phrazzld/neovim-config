-- Enable true color support
vim.opt.termguicolors = true

-- Get the current hour (0-23)
local current_hour = os.date("*t").hour

-- Determine theme mode based on time of day
_G.current_theme_mode = (current_hour >= 6 and current_hour < 18) and "light" or "dark"

-- Set background before colorscheme to avoid flicker
vim.opt.background = _G.current_theme_mode

-- Try to set the preferred colorscheme, fall back to a default if not available
local function set_colorscheme(colorscheme, fallback)
    local ok, err = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not ok then
        vim.notify("Failed to load colorscheme '" .. colorscheme .. "': " .. err, vim.log.levels.WARN)
        if fallback then
            vim.notify("Falling back to " .. fallback .. " colorscheme", vim.log.levels.INFO)
            pcall(vim.cmd, "colorscheme " .. fallback)
        end
    end
end

-- Set the fixed colorscheme with fallback to default
set_colorscheme("rose-pine", "default")

-- Function to toggle between light and dark themes safely
function ToggleTheme()
	if _G.current_theme_mode == "dark" then
		-- Switch to light mode
		vim.opt.background = "light"
		_G.current_theme_mode = "light"
		
		-- Try to set the colorscheme safely
		pcall(function()
			set_colorscheme("rose-pine", "default")
		end)
		
		vim.notify("Switched to light theme", vim.log.levels.INFO)
	else
		-- Switch to dark mode
		vim.opt.background = "dark"
		_G.current_theme_mode = "dark"
		
		-- Try to set the colorscheme safely
		pcall(function()
			set_colorscheme("rose-pine", "default")
		end)
		
		vim.notify("Switched to dark theme", vim.log.levels.INFO)
	end
end

-- Bind the ToggleTheme function to <leader>th
vim.keymap.set("n", "<leader>th", ToggleTheme, { noremap = true, silent = true, desc = "Toggle light/dark theme" })