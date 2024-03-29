local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	vim.notify("failed to load treesitter")
	return
end

configs.setup({
	auto_install = true,
	ensure_installed = {
		"bash",
		"comment",
		"css",
		"diff",
		"dockerfile",
		"git_config",
		"gitattributes",
		"gitcommit",
		"gitignore",
		--[[ "go", ]]
		"html",
		"javascript",
		"jq",
		"json",
		"json5",
		"lua",
		"python",
		"regex",
		"ruby",
		"rust",
		"scss",
		"svelte",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	}, -- "all", or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "" }, -- list of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		--disable = { "" }, -- list of languages that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml", "ruby" } },
	rainbow = {
		enable = false,
		-- disable = { "jsx", "tsx" }, -- list of languages to disable plugin for
		extended_mode = true, -- also highlight non-bracket delimiters like html tags
		max_file_lines = nil, -- do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of color name strings
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})
