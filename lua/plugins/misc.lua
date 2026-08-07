-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
	},
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
		lazy = true,
		event = { "BufReadPost" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- {
	-- 	-- High-performance color highlighter
	-- 	"norcalli/nvim-colorizer.lua",
	-- 	config = function()
	-- 		require("colorizer").setup()
	-- 	end,
	-- },
}
