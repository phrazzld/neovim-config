local M = {}

M.setup = function()
	-- disable netrw at the very start of your init.lua
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- set termguicolors to enable highlight groups
	vim.opt.termguicolors = true

	-- Try to load nvim-tree with error handling
	local ok, nvim_tree = pcall(require, "nvim-tree")
	if not ok then
		vim.notify("Failed to load nvim-tree", vim.log.levels.WARN)
		return
	end

	-- Setup with options
	nvim_tree.setup({
		sort_by = "case_sensitive",
		view = {
			width = 30,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
	})
end

-- Function to check if nvim-tree is available without loading it
function M.is_available()
	local ok, _ = pcall(require, "nvim-tree")
	return ok
end

return M