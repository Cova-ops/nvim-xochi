return {
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = "cd app && npm install",

		init = function()
			-- Solo para markdown
			vim.g.mkdp_filetypes = { "markdown" }

			-- Cierra preview al cerrar el buffer
			vim.g.mkdp_auto_close = 1

			-- No abrir automáticamente (lo controlas con keymaps)
			vim.g.mkdp_auto_start = 0

			-- Usa navegador por defecto (opcional)
			vim.g.mkdp_browser = "safari"
		end,

		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreview<CR>", desc = "Markdown Preview" },
			{ "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", desc = "Markdown Stop Preview" },
			{ "<leader>mt", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Toggle Preview" },
		},
	},
}
