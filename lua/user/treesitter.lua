local M = {}

function M.setup()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		return
	end
	
	-- Configure TreeSitter installation parameters for proper ARM64 compilation
	local ts_install = require("nvim-treesitter.install")
	ts_install.prefer_git = true
	ts_install.compilers = { "clang" }
	
	-- BUGFIX: Parser errors due to architecture mismatch
	-- Delete any parsers compiled for x86_64 instead of arm64 and reinstall them
	local system_arch = vim.fn.system("uname -m"):gsub("\n", "")
	
	if system_arch == "arm64" then
		-- Get parser directory
		local parser_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser/"
		
		-- Define parsers to check (those in ensure_installed plus any others commonly used)
		local parsers_to_check = {
			"bash", "lua", "python", "javascript", "typescript", "tsx", 
			"html", "css", "json", "yaml", "toml", "go", "rust"
		}
		
		-- Check each parser
		for _, parser_name in ipairs(parsers_to_check) do
			local parser_path = parser_dir .. parser_name .. ".so"
			local file_exists = vim.fn.filereadable(parser_path) == 1
			
			if file_exists then
				local parser_arch = vim.fn.system("file " .. parser_path)
				-- If parser is x86_64 on arm64 system, delete it so it can be reinstalled
				if parser_arch:match("x86_64") then
					vim.fn.delete(parser_path)
					
					-- Add to list of parsers to reinstall
					vim.defer_fn(function()
						vim.cmd("TSInstall " .. parser_name)
					end, 1000)
					
					vim.notify("Reinstalling " .. parser_name .. " parser for arm64 architecture", vim.log.levels.INFO)
				end
			end
		end
	end
	
	-- Don't delete parser files every time - this causes reinstallation
	-- Only delete them once during manual repair

	treesitter.setup({
		ensure_installed = {
			"lua",
			-- Don't auto-install markdown parsers - we'll manually install them
			-- "markdown",
			-- "markdown_inline",
			"bash",
			"javascript",
			"typescript",
			"tsx",
			"latex", -- Added for render-markdown.nvim LaTeX support
			"html",  -- Added for render-markdown.nvim HTML comment support
		},
		sync_install = false, -- Don't force synchronous installation
		auto_install = false, -- Disable auto-install to prevent reinstallation
		highlight = { 
			enable = true,
			-- Disable highlighting for gitignore files to prevent parser errors in Neovim 0.11.0
			disable = function(lang, bufnr)
				local filename = vim.fn.expand("%:t")
				return (lang == "gitignore" or (filename == ".gitignore" and lang == "gitignore"))
			end
		},
		indent = { enable = true },
	})
end

return M