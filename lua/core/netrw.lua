vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 35
vim.g.netrw_keepdir = 1

vim.g.netrw_list_hide = [[^\.\.\?$]]
vim.g.netrw_sort_sequence = [[[\/]$,*,\.bak$,\.o$,\.obj$,\.info$,\.swp$,\.tmp$]]

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true, noremap = true }

		vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
		vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
		vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
		vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
	end,
})
