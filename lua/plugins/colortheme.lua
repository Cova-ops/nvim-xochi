-- return 	{
--     'folke/tokyonight.nvim',
--     priority = 1000,
--     config = function()
--         require('tokyonight').setup {
--             style = "storm",
--             transparent = true,
--             -- terminal_colors = true,
--             styles = {
--                 -- sidebars = "transparent",
--                 -- floats = "transparent",
--             },
--         }
--         vim.cmd.colorscheme 'tokyonight'
--     end,
-- }

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha", -- opciones: latte, frappe, macchiato, mocha
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
