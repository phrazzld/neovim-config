local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then
  vim.notify("lsp-installer failed to load")
  return
end

-- register a handler that will be called for all installed servers
-- alternatively, you may also register handlers on specific server instances instead (see below example)
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server.name == "jsonls" then
    local jsonls_opts = require("user.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server.name == "sumneko_lua" then
    local sumneko_opts = require("user.lsp.settings.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server.name == "tsserver" then
    local tsserver_opts = require("user.lsp.settings.tsserver")
    opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
  end

  -- this setup() function is exactly the same as lspconfig's setup function
  -- refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
