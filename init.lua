-- disable netrw as early as possible
--[[ vim.g.loaded_netrw = 1 ]]
--[[ vim.g.loaded_netrwPlugin = 1 ]]
require("user.options")
require("user.keymappings")
require("user.plugins")
require("user.colorscheme")
require("user.cmp")
require("user.lsp")
require("user.telescope")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.nvim-tree")
require("user.toggleterm")
require("user.lualine")
require("user.markdown")
require("user.autocmds")
require("hop").setup()
require("colorizer").setup()
require("user.trouble")
require("user.todo-comments")
require("hardtime").setup()
