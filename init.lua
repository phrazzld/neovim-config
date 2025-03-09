-- Optimize startup time by minimizing initial loads
vim.loader.enable()  -- Use Neovim's faster loader feature

-- Setup plugins first so colorscheme is available
require("user.lazy").setup() -- Must be loaded first - loads plugins

-- Set core functionality
require("user.options").setup() -- Core Neovim options
require("user.keymappings").setup() -- Basic keymaps only

-- Set colorscheme after plugins are loaded
require("user.colorscheme").setup() -- Load after plugins to ensure colorscheme is available

-- Defer non-essential components to after startup
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- Schedule non-critical components with delays
        vim.defer_fn(function()
            pcall(function() require("user.lsp").setup() end)
            pcall(function() require("user.autocmds").setup() end)
        end, 100)
        
        vim.defer_fn(function()
            pcall(function() require("user.markdown").setup() end)
            -- TypeScript is now configured directly in lazy.lua
        end, 200)
        
        vim.defer_fn(function()
            -- Load very heavy components last
            pcall(function() require("user.supermaven").setup() end)
            pcall(function() 
                local ok, go = pcall(require, "go")
                if ok then go.setup() end
            end)
        end, 500)
    end
})