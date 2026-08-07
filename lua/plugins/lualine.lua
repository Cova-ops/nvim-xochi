return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				always_divide_middle = true,
			},

			sections = {},
			inactive_sections = {},

			winbar = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return " " .. str:sub(1, 3)
						end,
					},
				},

				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},

				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = {
							error = " ",
							warn = " ",
						},
						colored = false,
						update_in_insert = false,
						cond = hide_in_width,
					},
					"branch",
				},

				lualine_y = { "location" },
			},

			inactive_winbar = {
				lualine_c = {
					{ "filename", path = 1 },
				},
			},
		})

		vim.opt.laststatus = 0
	end,
}
