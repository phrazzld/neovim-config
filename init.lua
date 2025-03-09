-- Only load the base requirements
require("user.lazy")
require("user.options")
require("user.keymappings")
require("user.colorscheme")
require("user.lsp")
require("user.markdown")
require("user.autocmds")
require("user.typescript").setup()
require("user.supermaven")

-- Go setup is deferred since it's heavy
vim.defer_fn(function()
	require("go").setup()
end, 100)