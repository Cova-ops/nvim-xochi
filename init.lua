require("core.options")
require("core.keymaps")
require("core.snippets")
require("core.autoread")

-- Own
require("own.run")

vim.api.nvim_set_hl(0, "SysInfoOk", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "SysInfoWarn", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "SysInfoHigh", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "SysInfoDim", { link = "Comment" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
