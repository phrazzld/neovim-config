-- Make spacebar the leader key
vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

-- sensible defaults
require('settings')

-- Auto install packer.nvim if not exists
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
-- Auto compile when there are changes in plugins.lua
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' 

-- keymappings
require('keymappings')

-- plugins
require('plugins')

-- plugin configs
require('config')
