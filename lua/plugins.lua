return require('packer').startup(function()
  
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }

  -- colorscheme
  use { 'sainnhe/gruvbox-material' }

  -- fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{ 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' }}
  }

  -- lua development
  use { 'tjdevries/nlua.nvim' }

  -- lsp and completion
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/completion-nvim' }

  -- git management
  use { 'tpope/vim-fugitive' }

end)
