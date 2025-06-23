local M = {}

M.config = {
	model = "gemma3:4b",
	url = "http://localhost:11434",
	timeout = 30000,
	keymap = "<leader>ll"
}

local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	
	local lines = vim.api.nvim_buf_get_lines(
		0, start_pos[2] - 1, end_pos[2], false
	)
	
	if #lines == 0 then
		return ""
	end
	
	-- Handle partial line selection
	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
	else
		lines[1] = string.sub(lines[1], start_pos[3])
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end
	
	return table.concat(lines, '\n')
end

local function query_llm(prompt, callback)
	local response_data = {}
	
	-- Build curl command array
	local json_payload = vim.fn.json_encode({
		model = M.config.model,
		prompt = prompt,
		stream = false
	})
	
	local curl_cmd = {
		'curl', '-s', '-X', 'POST',
		M.config.url .. '/api/generate',
		'-H', 'Content-Type: application/json',
		'-d', json_payload,
		'--max-time', tostring(M.config.timeout / 1000),
		'--connect-timeout', '10'
	}
	
	-- Start job with async handlers
	local job_id = vim.fn.jobstart(curl_cmd, {
		on_stdout = function(_, data, _)
			vim.list_extend(response_data, data)
		end,
		on_exit = function(_, exit_code, _)
			vim.schedule(function()
				if exit_code == 0 then
					local response = table.concat(response_data, '\n')
					local ok, json = pcall(vim.fn.json_decode, response)
					if ok and json.response then
						callback(json.response)
					else
						vim.notify("Invalid LLM response", vim.log.levels.ERROR)
					end
				else
					vim.notify("LLM request failed (exit code: " .. exit_code .. ")", vim.log.levels.ERROR)
				end
			end)
		end
	})
	
	return job_id
end

local function insert_response(text, after_line)
	if not text or text == "" then
		return
	end
	
	-- Split text by newlines and transform to blockquote format
	local lines = vim.split(text, '\n')
	local quoted_lines = {""}  -- Start with blank line for spacing
	
	for _, line in ipairs(lines) do
		table.insert(quoted_lines, '> ' .. line)
	end
	
	-- Insert after selection using nvim_buf_set_lines
	vim.api.nvim_buf_set_lines(0, after_line, after_line, false, quoted_lines)
end

local function handle_query(args)
	-- Extract visual selection and validate
	local selection = get_visual_selection()
	if selection == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end
	
	-- Display progress notification
	vim.notify("Querying LLM...", vim.log.levels.INFO)
	
	-- Capture insertion point before async call
	local insert_line = vim.fn.line("'>")
	
	-- Make LLM request with callback
	query_llm(selection, function(response)
		insert_response(response, insert_line)
		vim.notify("Response received", vim.log.levels.INFO)
	end)
end

M.setup = function(opts)
	if vim.fn.executable('curl') == 0 then
		vim.notify("curl not found. Please install curl.", vim.log.levels.ERROR)
		return
	end
	
	opts = opts or {}
	M.config = vim.tbl_extend("force", M.config, opts)
	
	-- Register command
	vim.api.nvim_create_user_command('LLMQuery', handle_query, {
		range = true,
		desc = "Query LLM with selected text"
	})
	
	-- Register keymap
	vim.keymap.set('v', M.config.keymap, ':LLMQuery<CR>', {
		noremap = true,
		silent = true,
		desc = "Query LLM"
	})
end

return M