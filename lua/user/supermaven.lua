local M = {}

function M.setup()
    local ok, supermaven = pcall(require, "supermaven-nvim")
    if not ok then
        vim.notify("Failed to load Supermaven AI assistant", vim.log.levels.WARN)
        return
    end

    supermaven.setup({
        keymaps = {
            accept_suggestion = "<leader><Tab>",
        },
        ignore_filetypes = {
            markdown = true,
        },
        log_level = "info",
    })
end

return M