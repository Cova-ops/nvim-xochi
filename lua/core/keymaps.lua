-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = {
	noremap = true,
	silent = true,
}

-- Helper for creating keymaps
local function map(mode, lhs, rhs, desc, extra_opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }, extra_opts or {}))
end

-- Save all buffers without formatting
map("n", "<leader>wA", "<cmd>wall<CR>", "Save all (no format)")

-- Quit current window
map("n", "<C-q>", "<cmd>q<CR>", "Quit window")

-- Delete character without yanking
map("n", "x", '"_x', "Delete character")

-- Vertical scroll and center
map("n", "<C-d>", "<C-d>zz", "Half page down")
map("n", "<C-u>", "<C-u>zz", "Half page up")

-- Find and center
map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Previous search result")

-- Resize with arrows
map("n", "<Up>", ":resize -2<CR>", "Decrease window height")
map("n", "<Down>", ":resize +2<CR>", "Increase window height")
map("n", "<Left>", ":vertical resize -2<CR>", "Decrease window width")
map("n", "<Right>", ":vertical resize +2<CR>", "Increase window width")

-- Buffers
map("n", "<Tab>", ":bnext<CR>", "Next buffer")
map("n", "<S-Tab>", ":bprevious<CR>", "Previous buffer")
map("n", "<leader>x", ":bp | bd #<CR>", "Close current buffer")
map("n", "<leader>xo", ":%bd|e#|bd#<CR>", "Close all other buffers")
map("n", "<leader>b", "<cmd>enew<CR>", "New buffer")

-- Window management
map("n", "<leader>v", "<C-w>v", "Vertical split")
map("n", "<leader>h", "<C-w>s", "Horizontal split")
map("n", "<leader>se", "<C-w>=", "Equalize splits")
map("n", "<leader>xs", ":close<CR>", "Close split")

-- Navigate between splits
map("n", "<C-k>", ":wincmd k<CR>", "Focus upper split")
map("n", "<C-j>", ":wincmd j<CR>", "Focus lower split")
map("n", "<C-h>", ":wincmd h<CR>", "Focus left split")
map("n", "<C-l>", ":wincmd l<CR>", "Focus right split")

-- Tabs
map("n", "<leader>to", ":tabnew<CR>", "New tab")
map("n", "<leader>tx", ":tabclose<CR>", "Close tab")
map("n", "<leader>tn", ":tabnext<CR>", "Next tab")
map("n", "<leader>tp", ":tabprevious<CR>", "Previous tab")

-- Toggle line wrapping
map("n", "<leader>lw", "<cmd>set wrap!<CR>", "Toggle line wrap")

-- Stay in indent mode
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

-- Keep last yanked when pasting
map("v", "p", '"_dP', "Paste without replacing register")

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic")
map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")
