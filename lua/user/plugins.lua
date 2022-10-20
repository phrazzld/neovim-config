local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer, close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- reload neovim whenever plugins.lua is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- use a protected call so we don't error out on first use
local ok, packer = pcall(require, "packer")
if not ok then
  print("Protected call to require packer failed")
  return
end

-- run packer in a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- install all the plugins
return packer.startup(function(use)
  -- packer can manage itself
  use("wbthomason/packer.nvim")

  -- Pair programming is best, even with a robot
  use("github/copilot.vim")

  -- common plugin dependencies
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")

  -- colorschemes
  --[[ use("sainnhe/gruvbox-material") ]]
  use("folke/tokyonight.nvim")

  -- fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  })

  -- lsp
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("jose-elias-alvarez/null-ls.nvim") -- formatting and linting

  -- completions
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("saadparwaiz1/cmp_luasnip")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")

  -- snippets
  use("L3MON4D3/LuaSnip")
  use("rafamadriz/friendly-snippets")

  -- treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("p00f/nvim-ts-rainbow") -- colored parens

  use("windwp/nvim-autopairs")

  -- easy comments
  use("numToStr/Comment.nvim")
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- git
  use("lewis6991/gitsigns.nvim")
  use("tpope/vim-fugitive")

  -- file tree
  use("kyazdani42/nvim-web-devicons")
  use("kyazdani42/nvim-tree.lua")

  -- terminal
  use("akinsho/toggleterm.nvim")

  -- statusline
  use("nvim-lualine/lualine.nvim")

  -- get around faster within a buffer
  use({
    "phaazon/hop.nvim",
    branch = "v1",
  })

  -- show colors in files
  use("norcalli/nvim-colorizer.lua")

  -- better indents
  use("tpope/vim-sleuth")

  -- languages
  use("tjdevries/nlua.nvim")
  use("ray-x/go.nvim")
  use("rust-lang/rust.vim")
  use("kchmck/vim-coffee-script")
  use("slim-template/vim-slim")

  -- better markdown editing
  --[[ use({ ]]
  --[[   "Pocco81/true-zen.nvim", ]]
  --[[   config = function() ]]
  --[[            require("true-zen").setup {} ]]
  --[[   end, ]]
  --[[ }) ]]
  use("junegunn/goyo.vim")
  use({ "ellisonleao/glow.nvim", branch = "main" })
  use("preservim/vim-markdown")

  -- diagnostics management
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  })
  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim"
  })

  -- vim sugar for unix shell commands
  use("tpope/vim-eunuch")

  -- make it easy to add surrounding characters
  use("tpope/vim-surround")

  -- automatically set up config after cloning packer.nvim
  -- keep this at the end of this block, after all the other plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
