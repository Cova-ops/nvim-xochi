-- Terminal Configuration

-- For conciseness
local opts = {
	noremap = true,
	silent = true,
}

-- Helper for creating keymaps
local function map(mode, lhs, rhs, desc, extra_opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }, extra_opts or {}))
end

-- Exit terminal mode
map("t", "<Esc>", [[<C-\><C-n>]], "Exit from Terminal mode")

-- Change split
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Focus upper split")
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], "Focus lower split")
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Focus left split")
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], "Focus right split")

-- keymaps for starting a terminal in a split
map("n", "<leader>tv", function()
	vim.cmd("vsplit | terminal")
	vim.cmd("startinsert")
end, "Terminal Vertical")

map("n", "<leader>th", function()
	vim.cmd("split | terminal")
	vim.cmd("startinsert")
end, "Terminal Horizontal")
