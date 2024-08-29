require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<leader><Tab>",
	},
	ignore_filetypes = {
		markdown = true,
	},
	log_level = "info",
})
