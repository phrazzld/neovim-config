local indent = 2

local options = {
  backup = false,
  cmdheight = 2,
  completeopt = { "menuone", "noselect" },
  pumheight = 10,
  timeoutlen = 1000,
  updatetime = 300,
  writebackup = false,
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
