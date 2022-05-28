vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'

local indent = 2

local options = {
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
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
