vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

_G.custom_fold_text = function()
  return vim.fn.getline(vim.v.foldstart) .. " …"
end

vim.opt.foldtext = "v:lua.custom_fold_text()"
