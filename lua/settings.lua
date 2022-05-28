vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'
vim.cmd 'colorscheme darkblue'

local indent = 2

-- global options
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.scrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.visualbell = true
vim.o.incsearch = true
vim.o.hlsearch = false

-- buffer only options
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.shiftwidth = indent
vim.bo.softtabstop = indent
vim.bo.tabstop = indent
vim.bo.swapfile = false

-- window only options
vim.wo.number = true
vim.wo.relativenumber = true

-- colorscheme
vim.cmd 'colorscheme gruvbox-material'
