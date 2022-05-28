vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'
vim.cmd 'colorscheme gruvbox-material'

local indent = 2

local options = {
  termguicolors = true,
  hidden = true,
  scrolloff = 8,
  sidescrolloff = 8,
  splitbelow = true,
  splitright = true,
  visualbell = true,
  incsearch = true,
  hlsearch = false,
  expandtab = true,
  smartindent = true,
  shiftwidth = indent,
  softtabstop = indent,
  tabstop = indent,
  swapfile = false,
  number = true,
  relativenumber = true,
  wrap = false,
  cursorline = true,
  background = 'light'
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
