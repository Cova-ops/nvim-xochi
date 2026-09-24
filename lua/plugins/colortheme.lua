return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = {
			flavour = "macchiato",
		},
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		lazy = false,
		opts = {
			variant = "dawn",
		},
		config = function(_, opts)
			require("rose-pine").setup(opts)

			local current_mode = nil

			local function update_theme()
				local result = vim.system({
					"defaults",
					"read",
					"-g",
					"AppleInterfaceStyle",
				}, { text = true }):wait()

				local mode = result.code == 0 and "dark" or "light"

				-- Only change the theme when the mode actually changes
				if mode == current_mode then
					return
				end

				current_mode = mode

				if mode == "dark" then
					vim.o.background = "dark"
					vim.cmd.colorscheme("catppuccin-macchiato")
				else
					vim.o.background = "light"
					vim.cmd.colorscheme("rose-pine-dawn")
				end
			end

			-- Check immediately when Neovim starts
			update_theme()

			-- Check every 30 minutes
			local timer = vim.uv.new_timer()

			timer:start(30 * 60 * 1000, 30 * 60 * 1000, vim.schedule_wrap(update_theme))
		end,
	},
}
