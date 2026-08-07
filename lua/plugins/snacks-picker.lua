-- Snacks Picker is a fuzzy finder that can search files, grep text,
-- inspect buffers, diagnostics, keymaps, help pages, LSP results, and more.
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		picker = {
			-- Replace vim.ui.select() with Snacks Picker.
			ui_select = true,

			-- Keep the default Snacks layout for now so we can fairly compare
			-- its UX against Telescope before customizing anything.
			layout = {
				preset = "default",
			},

			-- Global picker keymaps.
			win = {
				input = {
					keys = {
						-- Move through results.
						["<C-j>"] = { "list_down", mode = { "i", "n" } },
						["<C-k>"] = { "list_up", mode = { "i", "n" } },

						-- Open selected result.
						["<C-l>"] = { "confirm", mode = { "i", "n" } },

						-- Scroll the preview without opening the file.
						["<C-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<C-f>"] = { "preview_scroll_down", mode = { "i", "n" } },

						-- Open in split / vertical split.
						["<C-s>"] = { "edit_split", mode = { "i", "n" } },
						["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
					},
				},
			},

			sources = {
				files = {
					-- Include hidden files such as .env.
					hidden = true,

					-- Also include files ignored by .gitignore.
					ignored = true,

					-- Since ignored files are enabled, explicitly exclude
					-- directories we normally do not want to search.
					exclude = {
						".git",
						"node_modules",
						"dist",
						"build",
						"coverage",
						".next",
					},
				},

				grep = {
					-- Search hidden and ignored files such as .env.
					hidden = true,
					ignored = true,

					-- Exclude generated/large directories and lock files.
					exclude = {
						".git",
						"node_modules",
						"dist",
						"build",
						"coverage",
						".next",
						"package-lock.json",
						"yarn.lock",
						"pnpm-lock.yaml",
					},
				},
			},
		},
	},

	keys = {
		-- See available Snacks pickers.
		{
			"<leader>ss",
			function()
				Snacks.picker()
			end,
			desc = "[S]earch [S]elect Picker",
		},

		-- Search help tags.
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "[S]earch [H]elp",
		},

		-- Search Neovim keymaps.
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},

		-- Find files.
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "[S]earch [F]iles",
		},

		-- Search the word under the cursor.
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "[S]earch current [W]ord",
			mode = { "n", "x" },
		},

		-- Live grep across the project.
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "[S]earch by [G]rep",
		},

		-- Search diagnostics.
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},

		-- Resume the previous picker.
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "[S]earch [R]esume",
		},

		-- Search recent files.
		{
			"<leader>s.",
			function()
				Snacks.picker.recent()
			end,
			desc = '[S]earch Recent Files ("." for repeat)',
		},

		-- Find existing buffers.
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[ ] Find existing buffers",
		},

		-- Fuzzily search in the current buffer.
		{
			"<leader>/",
			function()
				Snacks.picker.lines({
					layout = {
						preview = "right",
						preset = "default",
					},
				})
			end,
			desc = "[/] Fuzzily search in current buffer",
		},

		-- Live grep only in currently open buffers.
		{
			"<leader>s/",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "[S]earch [/] in Open Files",
		},
	},
}
