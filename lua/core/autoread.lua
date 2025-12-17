vim.o.autoread = true -- Auto read all file id it has changes

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
  pattern = "*",
})
