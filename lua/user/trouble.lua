local M = {}

function M.setup()
	local ok, _ = pcall(require, "trouble")
	if not ok then
		vim.notify("Failed to load trouble", vim.log.levels.WARN)
		return
	end
end

return M
