local M = {}

M.setup = function()
	local ok, trouble = pcall(require, "trouble")
	if not ok then
		return
	end
end

return M