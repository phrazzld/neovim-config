local M = {}

function M.setup()
	-- vim-markdown config
	vim.g.vim_markdown_folding_disabled = true
	
	-- Using pcall to check for parser without triggering installation
	local ts_ok = pcall(function()
		-- Use non-deprecated way to check parser availability
		local parsers = require("nvim-treesitter.parsers")
		return parsers.has_parser("markdown")
	end)
	
	if not ts_ok then
		-- If TreeSitter parser is not available, use only vim-markdown
		-- Don't show notification every time - it's annoying
		return
	end

	-- render-markdown.nvim config
	local status_ok, render_markdown = pcall(require, "render-markdown")
	if not status_ok then
		return
	end

	render_markdown.setup({
		-- Enable markdown rendering by default
		enabled = true,
		-- Render in normal, command, and terminal modes
		render_modes = { "n", "c", "t" },
		-- Don't try to render files larger than 10MB
		max_file_size = 10.0,
		-- Filetypes to activate the plugin for
		file_types = { "markdown" },
		-- Enable enhanced markdown features
		heading = {
			-- Make headings stand out with background colors
			width = "full",
			-- Add a border below headings for better visual separation
			border = true,
			-- Customize heading icons
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		code = {
			-- Full language and style rendering for code blocks
			style = "full",
			-- Show language name and icon
			language_name = true,
			language_icon = true,
			-- Full width code blocks
			width = "full",
			-- Add a thin border around code blocks
			border = "thin",
		},
		bullet = {
			-- Nice unicode bullets for lists 
			icons = { "●", "○", "◆", "◇" },
			-- Add right padding for better readability
			right_pad = 1,
		},
		checkbox = {
			-- Enable checkbox rendering
			enabled = true,
			-- Add custom checkbox states
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
				important = { raw = "[!]", rendered = "󰀦 ", highlight = "RenderMarkdownWarn" },
				done = { raw = "[d]", rendered = "󰄬 ", highlight = "RenderMarkdownSuccess" },
			},
		},
		pipe_table = {
			-- Enable full table rendering with borders
			style = "full",
			cell = "padded",
			padding = 1,
		},
		dash = {
			-- Nicer horizontal rule rendering
			icon = "─",
			width = "full",
		},
		-- Pretty callouts rendering (similar to Obsidian/GitHub)
		callout = {
			-- GitHub style callouts
			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo", category = "github" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess", category = "github" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint", category = "github" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn", category = "github" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError", category = "github" },
		},
		-- Enable in-process LSP completions for checkboxes and callouts
		completions = {
			lsp = { enabled = true },
		},
		-- Anti-conceal behavior (don't render on cursor line)
		anti_conceal = {
			enabled = true,
			ignore = {
				code_background = true,
				sign = true,
			},
		},
	})

	-- Key mappings for render-markdown.nvim
	vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { noremap = true, silent = true, desc = "Toggle Markdown Rendering" })
	vim.keymap.set("n", "<leader>me", "<cmd>RenderMarkdown expand<CR>", { noremap = true, silent = true, desc = "Expand Markdown Anti-conceal" })
	vim.keymap.set("n", "<leader>mc", "<cmd>RenderMarkdown contract<CR>", { noremap = true, silent = true, desc = "Contract Markdown Anti-conceal" })
end

return M