-- Optimize startup time by minimizing initial loads
vim.loader.enable()  -- Use Neovim's faster loader feature

-- Setup plugins first so colorscheme is available
require("user.lazy") -- Must be loaded first - loads plugins

-- Set core functionality
require("user.options") -- Core Neovim options
require("user.keymappings") -- Basic keymaps only

-- Set colorscheme after plugins are loaded
require("user.colorscheme") -- Load after plugins to ensure colorscheme is available

-- Defer non-essential components to after startup
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- Schedule non-critical components with delays
        vim.defer_fn(function()
            pcall(require, "user.lsp")
            pcall(require, "user.autocmds")
        end, 100)
        
        vim.defer_fn(function()
            pcall(require, "user.markdown")
            if pcall(require, "user.typescript") then
                pcall(require("user.typescript").setup)
            end
        end, 200)
        
        vim.defer_fn(function()
            -- Load very heavy components last
            pcall(require, "user.supermaven")
            if pcall(require, "go") then
                require("go").setup()
            end
        end, 500)
    end
})