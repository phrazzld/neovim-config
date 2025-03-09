-- Helper for safe module loading
local function safe_require(module, fallback_fn)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("Error loading " .. module .. "\n" .. result, vim.log.levels.WARN)
        if fallback_fn then
            fallback_fn()
        end
        return nil
    end
    return result
end

-- Core modules (these should never fail)
safe_require("user.lazy") -- must succeed for plugins to work
safe_require("user.options") 
safe_require("user.keymappings")
safe_require("user.colorscheme")

-- Feature modules with graceful degradation
local lsp_module = safe_require("user.lsp")
safe_require("user.markdown")
safe_require("user.autocmds")

-- Optional modules
local typescript = safe_require("user.typescript")
if typescript then
    pcall(typescript.setup)
end

-- External plugins with safe requires
pcall(function() 
    safe_require("user.supermaven")
end)

-- Go setup is deferred since it's heavy
vim.defer_fn(function()
    pcall(function()
        local go = safe_require("go")
        if go then
            go.setup()
        end
    end)
end, 100)