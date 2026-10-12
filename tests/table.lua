-- Run from the repository root: nvim --headless -u NONE -i NONE -l tests/table.lua
-- Only synthetic scratch buffers are used; init.lua and plugins are not loaded.
vim.opt.runtimepath:prepend(vim.fn.getcwd())
vim.g.mapleader = " "
vim.o.swapfile = false
vim.o.modeline = false

local formatter = require("user.table")
local passed = 0
local failures = {}

local function check(name, input, expected, action)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, input)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	local ok, err = pcall(function()
		(action or formatter.format)()
		assert(vim.deep_equal(expected, vim.api.nvim_buf_get_lines(buf, 0, -1, false)),
			"expected " .. vim.inspect(expected) .. "\ngot " .. vim.inspect(vim.api.nvim_buf_get_lines(buf, 0, -1, false)))
		local cursor = vim.api.nvim_win_get_cursor(0)
		formatter.format()
		assert(vim.deep_equal(expected, vim.api.nvim_buf_get_lines(buf, 0, -1, false)), "not idempotent")
		assert(vim.deep_equal(cursor, vim.api.nvim_win_get_cursor(0)), "cursor moved on repeat")
	end)
	vim.api.nvim_buf_delete(buf, { force = true })
	if ok then
		passed = passed + 1
	else
		table.insert(failures, name .. ": " .. tostring(err))
	end
end

local escaped_input = { "| A | B |", "| --- | --- |", [[| x\|y | z |]] }
local escaped_expected = { "| A    | B   |", "| :--- | :-- |", [[| x\|y | z   |]] }
check("escaped pipe", escaped_input, escaped_expected)
check("ordinary table", { "| A | B |", "| --- | --- |", "| x | z |" }, {
	"| A   | B   |", "| :-- | :-- |", "| x   | z   |",
})

-- GFM example 200: escaped pipes stay in cells, including inside code spans.
-- https://github.github.com/gfm/#example-200
check("escaped pipe in code", { "| A | B |", "| --- | --- |", [[| `x\|y` | z |]] }, {
	"| A      | B   |", "| :----- | :-- |", [[| `x\|y` | z   |]],
})
check("bare pipe in code is a separator", { "| A | B | C |", "| --- | --- | --- |", "| `x|y` | z |" }, {
	"| A   | B   | C   |", "| :-- | :-- | :-- |", "| `x  | y`  | z   |",
})

-- cmark-gfm's table scanner keeps a pipe after any nonempty backslash run.
-- This is intentionally not the odd/even rule for ordinary inline escapes.
-- https://github.com/github/cmark-gfm/blob/master/extensions/ext_scanners.re
for count = 1, 5 do
	for _, code in ipairs({ false, true }) do
		local cell = "x" .. string.rep("\\", count) .. "|y"
		if code then cell = "`" .. cell .. "`" end
		local width = #cell
		check("backslash run " .. count .. (code and " in code" or ""), {
			"| A | B |", "| --- | --- |", "| " .. cell .. " | z |",
		}, {
			"| A" .. string.rep(" ", width - 1) .. " | B   |",
			"| :" .. string.rep("-", width - 1) .. " | :-- |",
			"| " .. cell .. " | z   |",
		})
	end
end

for _, borders in ipairs({ { "", "" }, { "|", "" }, { "", "|" }, { "|", "|" } }) do
	check("optional borders " .. borders[1] .. "/" .. borders[2], {
		borders[1] .. " A | B " .. borders[2],
		borders[1] .. " --- | --- " .. borders[2],
		borders[1] .. [[ x\|y | z ]] .. borders[2],
	}, escaped_expected)
end

check("escaped trailing pipe is content", { "A | B", "--- | ---", [[x | y\|]] }, {
	"| A   | B   |", "| :-- | :-- |", [[| x   | y\| |]],
})
check("escaped trailing pipe with whitespace", { [[  | x | y\|   ]] }, { [[| x   | y\| |]] })
check("even backslash run at end of row", { [[| x | y\\|]] }, { [[| x   | y\\| |]] })
check("backslashes before space do not escape separator", { [[| x\\ | y |]] }, { [[| x\\ | y   |]] })
check("escaped leading pipe is content", { "A | B", "--- | ---", [[\|x | z]] }, {
	"| A   | B   |", "| :-- | :-- |", [[| \|x | z   |]],
})
check("escaped pipe beside closing border", { [[| x\||]] }, { [[| x\| |]] })
check("empty edge and middle cells", { "||x|||" }, { "|     | x   |     |     |" })
check("empty cells beside escaped pipe", { [[||x\|y||]] }, { [[|     | x\|y |     |]] })
check("single empty cell", { "| |" }, { "|     |" })
check("multiple escaped pipes", { [[| \|x\| | z |]] }, { [[| \|x\| | z   |]] })

check("left center and right alignment", {
	"| left | mid | right |", "| :--- | :---: | ---: |", [[| a\|b | c | d |]],
}, { "| left | mid | right |", "| :--- | :-: | ----: |", [[| a\|b |  c  |     d |]] })
check("Unicode display widths and raw bytes", {
	"| A | B |", "| --- | --- |", [[| 界\|語 | é |]],
}, { "| A      | B   |", "| :----- | :-- |", [[| 界\|語 | é   |]] })

local surrounded_input = { "Before", "", unpack(escaped_input) }
vim.list_extend(surrounded_input, { "", "After" })
local surrounded_expected = { "Before", "", unpack(escaped_expected) }
vim.list_extend(surrounded_expected, { "", "After" })
check("only current table changes and cursor stays put", surrounded_input, surrounded_expected, function()
	vim.api.nvim_win_set_cursor(0, { 5, 2 })
	formatter.format()
	assert(vim.deep_equal({ 5, 2 }, vim.api.nvim_win_get_cursor(0)), "cursor moved")
end)
check("non-table warning and no mutation", { "Plain text" }, { "Plain text" }, function()
	local notify = vim.notify
	local warnings = {}
	vim.notify = function(message, level) table.insert(warnings, { message, level }) end
	local ok, err = pcall(formatter.format)
	vim.notify = notify
	assert(ok, err)
	assert(vim.deep_equal(warnings, { { "Cursor is not inside a markdown table", vim.log.levels.WARN } }))
end)

local function load_markdown_ftplugin()
	dofile("after/ftplugin/markdown.lua")
end
check("MDTableFormat command", escaped_input, escaped_expected, function()
	load_markdown_ftplugin()
	vim.cmd("MDTableFormat")
end)
check("Space mf mapping", escaped_input, escaped_expected, function()
	load_markdown_ftplugin()
	local mapping = vim.fn.maparg(" mf", "n", false, true)
	assert(mapping.buffer == 1, "table mapping must remain buffer-local")
	vim.api.nvim_feedkeys(" mf", "xt", false)
end)

if #failures > 0 then
	io.stderr:write(table.concat(failures, "\n\n") .. "\n")
	io.stderr:write(string.format("%d passed; %d failed\n", passed, #failures))
	vim.cmd("cquit 1")
end
print(string.format("%d table formatter tests passed", passed))
