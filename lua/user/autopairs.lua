local M = {}

M.setup = function()
	local ok, npairs = pcall(require, "nvim-autopairs")
	if not ok then
		vim.notify("failed to load nvim-autopairs")
		return
	end

	npairs.setup({
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false,
		},
		disable_filetype = { "TelescopePrompt" },
		fast_wrap = {
			--map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0, -- offset from pattern match
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	})

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp_ok, cmp = pcall(require, "cmp")
	if not cmp_ok then
		vim.notif("failed to load autopairs cmp")
		return
	end
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end

return M