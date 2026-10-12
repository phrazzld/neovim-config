local M = {}

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function split_row(line)
	local content = trim(line)
	if content:sub(1, 1) == "|" then
		content = content:sub(2)
	end
	local cells = {}
	local start = 1
	for i = 1, #content do
		-- GFM table escapes apply even in code spans and after backslash runs.
		if content:sub(i, i) == "|" and content:sub(i - 1, i - 1) ~= "\\" then
			table.insert(cells, trim(content:sub(start, i - 1)))
			start = i + 1
		end
	end
	-- A final unescaped pipe is a border, not an extra empty cell.
	if start <= #content or #cells == 0 then
		table.insert(cells, trim(content:sub(start)))
	end
	return cells
end

local function is_delimiter_row(cells)
	if #cells == 0 then
		return false
	end
	for _, cell in ipairs(cells) do
		if not cell:match("^:?%-+:?$") then
			return false
		end
	end
	return true
end

local function get_alignment(cell)
	local left = cell:sub(1, 1) == ":"
	local right = cell:sub(-1, -1) == ":"
	if left and right then
		return "center"
	elseif right then
		return "right"
	else
		return "left"
	end
end

local function pad_cell(text, width, align)
	local len = vim.fn.strdisplaywidth(text)
	local pad = width - len
	if pad <= 0 then
		return text
	end
	if align == "right" then
		return string.rep(" ", pad) .. text
	elseif align == "center" then
		local left_pad = math.floor(pad / 2)
		local right_pad = pad - left_pad
		return string.rep(" ", left_pad) .. text .. string.rep(" ", right_pad)
	else
		return text .. string.rep(" ", pad)
	end
end

local function format_delimiter(width, align)
	if align == "center" then
		return ":" .. string.rep("-", math.max(1, width - 2)) .. ":"
	elseif align == "right" then
		return string.rep("-", math.max(1, width - 1)) .. ":"
	elseif align == "left" and width >= 3 then
		return ":" .. string.rep("-", math.max(1, width - 1))
	else
		return string.rep("-", width)
	end
end

function M.format()
	local bufnr = 0
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1]
	local total_lines = vim.api.nvim_buf_line_count(bufnr)

	local function is_table_line(l)
		return l and l:match("|") and not l:match("^%s*$")
	end

	local cur_line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
	if not is_table_line(cur_line) then
		vim.notify("Cursor is not inside a markdown table", vim.log.levels.WARN)
		return
	end

	local start_row = row
	while start_row > 1 do
		local prev_line = vim.api.nvim_buf_get_lines(bufnr, start_row - 2, start_row - 1, false)[1]
		if is_table_line(prev_line) then
			start_row = start_row - 1
		else
			break
		end
	end

	local end_row = row
	while end_row < total_lines do
		local next_line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1]
		if is_table_line(next_line) then
			end_row = end_row + 1
		else
			break
		end
	end

	local raw_lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
	local rows = {}
	local num_cols = 0
	local delim_idx = nil

	for i, line in ipairs(raw_lines) do
		local cells = split_row(line)
		table.insert(rows, cells)
		if #cells > num_cols then
			num_cols = #cells
		end
		if is_delimiter_row(cells) and not delim_idx then
			delim_idx = i
		end
	end

	if num_cols == 0 then
		return
	end

	local alignments = {}
	if delim_idx then
		for c = 1, num_cols do
			local cell = rows[delim_idx][c] or "---"
			alignments[c] = get_alignment(cell)
		end
	else
		for c = 1, num_cols do
			alignments[c] = "left"
		end
	end

	local col_widths = {}
	for c = 1, num_cols do
		col_widths[c] = 3
	end

	for i, cells in ipairs(rows) do
		if i ~= delim_idx then
			for c = 1, num_cols do
				local cell = cells[c] or ""
				local w = vim.fn.strdisplaywidth(cell)
				if w > col_widths[c] then
					col_widths[c] = w
				end
			end
		end
	end

	local formatted_lines = {}
	for i, cells in ipairs(rows) do
		local parts = {}
		if i == delim_idx then
			for c = 1, num_cols do
				table.insert(parts, format_delimiter(col_widths[c], alignments[c]))
			end
		else
			for c = 1, num_cols do
				local cell = cells[c] or ""
				table.insert(parts, pad_cell(cell, col_widths[c], alignments[c]))
			end
		end
		table.insert(formatted_lines, "| " .. table.concat(parts, " | ") .. " |")
	end

	vim.api.nvim_buf_set_lines(bufnr, start_row - 1, end_row, false, formatted_lines)
	vim.api.nvim_win_set_cursor(0, { math.min(row, #formatted_lines + start_row - 1), pos[2] })
end

return M
