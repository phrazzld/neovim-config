local M = {}

function M.setup()
	local ok, trouble = pcall(require, "trouble")
	if not ok then
		vim.notify("Failed to load trouble", vim.log.levels.WARN)
		return
	end
	
	-- Configure trouble settings if needed
	-- trouble.setup({
	--     -- Configuration options
	-- })
end

return M