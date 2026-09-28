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
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		priority = 1000,
		lazy = false,
		opts = {
			variant = "dawn",
		},
		config = function(_, opts)
			require("github-theme").setup({})

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
					vim.cmd.colorscheme("github_light_high_contrast")
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
