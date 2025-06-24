--[[
Neovim Inline LLM Integration

Allows querying local LLM models with full file context. The entire file content
is sent as context, with your visual selection as the specific question.
Select text in visual mode, press <leader>ll, and receive blockquoted responses
inserted directly into the buffer.

Requirements:
- Local Ollama installation (https://ollama.ai)
- curl command available in PATH
- Ollama model pulled (e.g., ollama pull gemma3:4b)

Usage:
1. Select text in visual mode (your specific question/request)
2. Press <leader>ll or run :LLMQuery
3. Response appears as blockquoted text after selection

How it works:
- The LLM receives the entire file content as context
- Your selected text is presented as the specific question
- This allows the LLM to understand the broader context when answering

Example workflow:
  Before (in a large file with multiple functions):
    function add(a, b) { return a + b; }
    function multiply(a, b) { return a * b; }
    // Selected text: "explain this function"
    
  After selecting "explain this function" and pressing <leader>ll:
    function add(a, b) { return a + b; }
    function multiply(a, b) { return a * b; }
    // Selected text: "explain this function"
    
    > Based on the context of your file with mathematical functions, you're asking about
    > the add() function. This is a simple JavaScript function that takes two parameters
    > and returns their sum. It follows the same pattern as your multiply() function.
    >
    
Visual selection workflow:
  • Position cursor at start of text
  • Enter visual mode (v for characters, V for lines, <C-v> for block)
  • Extend selection to cover desired text
  • Press <leader>ll to query LLM
  • Wait for "Querying LLM..." then "Response received" notifications
  • LLM response appears as blockquoted text after selection

Configuration options available via setup({ model, url, timeout, keymap })

Troubleshooting:
  Common Issues:
  • "curl not found" error: Install curl via package manager
    - macOS: brew install curl
    - Ubuntu/Debian: sudo apt install curl
    - Windows: Use scoop install curl or install via Git for Windows
  
  • Connection errors: Verify Ollama is running
    - Check: curl http://localhost:11434/api/tags
    - Start: ollama serve (or restart Ollama app)
  
  • Timeout errors: Increase timeout for very complex queries
    - Example: require("user.llm").config.timeout = 180000
  
  • Model errors: Ensure model is downloaded
    - Example: ollama pull gemma3:4b
    - List models: ollama list
--]]

local M = {}

M.config = {
	model = "gemma3:4b",
	url = "http://localhost:11434",
	timeout = 120000,
	keymap = "<leader>ll"
}

local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	
	-- Additional safety check for unset marks
	if start_pos[2] == 0 or end_pos[2] == 0 then
		return ""
	end
	
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

local function get_full_buffer_content()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	
	if #lines == 0 then
		return ""
	end
	
	return table.concat(lines, '\n')
end

local function build_full_context_prompt(selection, full_content)
	return string.format("File context:\n%s\n\nSpecific question about the highlighted text:\n%s", 
		full_content, selection)
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
					local response = table.concat(response_data, '')
					local ok, json = pcall(vim.fn.json_decode, response)
					if not ok then
						vim.notify("Malformed JSON response from Ollama", vim.log.levels.ERROR)
					elseif json.error then
						vim.notify("Ollama error: " .. json.error, vim.log.levels.ERROR)
					elseif json.response then
						if json.response == "" then
							vim.notify("Empty response from LLM", vim.log.levels.WARN)
						else
							callback(json.response)
						end
					else
						vim.notify("Missing response field in Ollama output", vim.log.levels.ERROR)
					end
				else
					vim.notify("LLM request failed (exit code: " .. exit_code .. ")", vim.log.levels.ERROR)
				end
			end)
		end
	})
	
	return job_id
end

local function insert_response(bufnr, text, after_line)
	if not text or text == "" then
		return
	end
	
	-- Split text by newlines and transform to blockquote format
	local lines = vim.split(text, '\n')
	local quoted_lines = {""}  -- Start with blank line for spacing
	
	for _, line in ipairs(lines) do
		table.insert(quoted_lines, '> ' .. line)
	end
	
	-- Add trailing blank line for spacing
	table.insert(quoted_lines, "")
	
	-- Insert after selection using specific buffer
	vim.api.nvim_buf_set_lines(bufnr, after_line, after_line, false, quoted_lines)
end

local function handle_query(args)
	-- Extract visual selection and validate
	local selection = get_visual_selection()
	if selection:match("^%s*$") then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end
	
	-- Get full file content for context
	local full_content = get_full_buffer_content()
	local context_prompt = build_full_context_prompt(selection, full_content)
	
	-- Display progress notification
	vim.notify("Querying LLM...", vim.log.levels.INFO)
	
	-- Capture buffer and set persistent extmark for async safety
	local bufnr = vim.api.nvim_get_current_buf()
	local ns_id = vim.api.nvim_create_namespace("llm_plugin")
	local mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, vim.fn.line("'>") - 1, 0, {})
	
	-- Make LLM request with callback
	query_llm(context_prompt, function(response)
		vim.schedule(function()
			-- Validate buffer still exists
			if not vim.api.nvim_buf_is_valid(bufnr) then
				vim.notify("Buffer closed during query", vim.log.levels.WARN)
				return
			end
			
			-- Resolve extmark position at insertion time and clean up
			local mark_pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns_id, mark_id, {})
			if not mark_pos then
				vim.notify("Mark lost during query", vim.log.levels.WARN)
				return
			end
			vim.api.nvim_buf_del_extmark(bufnr, ns_id, mark_id)
			local insert_line = mark_pos[1] + 1
			
			insert_response(bufnr, response, insert_line)
			vim.notify("Response received", vim.log.levels.INFO)
		end)
	end)
end

--[[
Setup function for LLM integration

@param opts table|nil Configuration options (optional)
@param opts.model string Model name for Ollama (default: "gemma3:4b")
@param opts.url string Ollama server URL (default: "http://localhost:11434")
@param opts.timeout number Request timeout in milliseconds (default: 120000)
@param opts.keymap string Visual mode keymap to trigger LLM query (default: "<leader>ll")

Example usage:
  require("user.llm").setup({
    model = "llama3.2:3b",
    url = "http://localhost:11434",
    timeout = 180000,
    keymap = "<leader>ai"
  })
--]]
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