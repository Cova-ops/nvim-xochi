-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
	},
	-- {
	-- 	"mattn/emmet-vim",
	-- 	ft = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
	-- 	init = function()
	-- 		-- 🔥 Desactiva los mappings default (incluye <C-y>,)
	-- 		-- This need to be here, make conflicts with completion
	-- 		vim.g.user_emmet_install_global = 0
	--
	-- 		-- Para que Emmet funcione bien en JSX / TSX
	-- 		vim.g.user_emmet_settings = {
	-- 			javascriptreact = { extends = "jsx" },
	-- 			typescriptreact = { extends = "jsx" },
	-- 		}
	-- 	end,
	-- 	config = function()
	-- 		-- Expandir abreviación con Ctrl+e (SIN coma)
	-- 		vim.keymap.set("i", "<C-e>", "<Plug>(emmet-expand-abbr)", { silent = true })
	-- 	end,
	-- },
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- usa treesitter si existe
				enable_check_bracket_line = false,
			})
		end,
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		-- High-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
}
