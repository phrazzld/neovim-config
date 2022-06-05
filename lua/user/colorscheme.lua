vim.opt.termguicolors = true

local colorscheme = "gruvbox-material"

-- Use dark mode from 1800 - 0700
local hour = os.date("*t").hour

if hour > 17 or hour < 7 then
  vim.opt.background = "dark"
else
  vim.opt.background = "light"
end

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
