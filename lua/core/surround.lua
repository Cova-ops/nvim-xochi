local surrounds = {
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
  ["["] = "]",
  ["{"] = "}",
  ["("] = ")",
}

for open, close in pairs(surrounds) do
  vim.keymap.set("x", open, function()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

    vim.cmd('normal! "zc')
    local selected = vim.fn.getreg("z")

    vim.api.nvim_paste(open .. selected .. close, false, -1)
    vim.api.nvim_feedkeys(esc, "n", false)
  end, { desc = "Surround selection with " .. open })
end
