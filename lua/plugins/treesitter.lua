return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		install_dir = vim.fn.stdpath("data") .. "/site",
		auto_install = true,
	},
	config = function(_, opts)
		local ts = require("nvim-treesitter")
		ts.setup(opts)

		local languages = {
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
		}

		ts.install(languages)
	end,
}
