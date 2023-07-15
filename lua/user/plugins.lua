local fn = vim.fn
local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- function to install packer if it is not installed already
local function install_packer_if_needed(path)
	if fn.empty(fn.glob(path)) > 0 then
		local packer_repo_url = "https://github.com/wbthomason/packer.nvim"
		local install_cmd = {"git", "clone", "--depth", "1", packer_repo_url, path}

		local res, code = fn.system(install_cmd)
		if code ~= 0 then
			error("Failed to install packer: " .. res)
		end
		print("Installing packer, close and reopen Neovim...")
		vim.cmd([[packadd packer.nvim]])
		return true
	end
end

-- auto install packer if needed
local bootstrap = install_packer_if_needed(packer_path)

-- reload neovim whenever plugins.lua is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- use a protected call so we don't error out on first use
local ok, packer = pcall(require, "packer")
if not ok then
	print("Protected call to require packer failed")
	return
end

-- run packer in a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- install all the plugins
return packer.startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	-- Pair programming is best, even with a robot
	use("github/copilot.vim")

	-- common plugin dependencies
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")

	require("user.plugins.colorschemes")(use)
	require("user.plugins.lsp")(use)
	require("user.plugins.completions")(use)
	require("user.plugins.markdown")(use)
	require("user.plugins.navigation")(use)
	require("user.plugins.git")(use)
	require("user.plugins.snippets")(use)
	require("user.plugins.languages")(use)
	require("user.plugins.diagnostics")(use)
	require("user.plugins.utilities")(use)

	-- automatically set up config after cloning packer.nvim
	-- keep this at the end of this block, after all the other plugins
	if bootstrap then
		require("packer").sync()
	end
end)
