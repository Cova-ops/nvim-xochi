return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"shfmt",
				"checkmake",
			},
			automatic_installation = true,
		})

		local sources = {
			diagnostics.checkmake,

			formatting.prettier.with({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"json",
					"jsonc",
					"css",
					"scss",
					"html",
					"yaml",
					"markdown",
				},
			}),

			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),

			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
		}

		null_ls.setup({ sources = sources })

		-- Save with format
		vim.api.nvim_create_user_command("W", function()
			vim.lsp.buf.format({
				async = false,
			})

			vim.cmd("write")
		end, {})
	end,
}
