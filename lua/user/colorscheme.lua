vim.opt.termguicolors = true
-- vim.opt.background = "dark"
vim.opt.background = "light"

local colorscheme = "gruvbox-material"
-- local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
