vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local ok, vscode = pcall(require, "vscode")
if not ok then
  vim.notify("Failed to load vscode module", vim.log.levels.ERROR)
  return
end

local function call(cmd)
  return function()
    vscode.call(cmd)
  end
end

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

map("n", "gd", call("editor.action.revealDefinition"), opts)
map("n", "gr", call("editor.action.goToReferences"), opts)
map("n", "gi", call("editor.action.goToImplementation"), opts)
map("n", "K", call("editor.action.showHover"), opts)
map("n", "zz", "zz", opts)

-- core/keymaps.lua
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)