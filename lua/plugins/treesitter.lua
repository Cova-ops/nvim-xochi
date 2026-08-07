return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local ts = require("nvim-treesitter")

		ts.setup()

		ts.install({
			"lua",
			"javascript",
			"typescript",
			"tsx",
			"python",
			"rust",
			"go",
			"html",
			"css",
			"json",
			"yaml",
			"toml",
			"bash",
			"markdown",
			"markdown_inline",
		})
	end,
}
