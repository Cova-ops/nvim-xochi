return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",

	dependencies = {
		-- Adds LSP completion capabilities to nvim-cmp.
		"hrsh7th/cmp-nvim-lsp",

		-- Adds words from the current buffer as completion candidates.
		"hrsh7th/cmp-buffer",

		-- Adds filesystem paths as completion candidates.
		"hrsh7th/cmp-path",
	},

	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")

		local kind_icons = {
			Text = "󰉿",
			Method = "m",
			Function = "󰊕",
			Constructor = "",
			Field = "",
			Variable = "󰆧",
			Class = "󰌗",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰇽",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		}

		cmp.setup({
			-- Neovim 0.10+ includes a native snippet engine.
			-- This is enough to expand snippets returned by LSP servers,
			-- so LuaSnip is not necessary unless you want custom snippet collections.
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},

			completion = {
				completeopt = "menu,menuone,noselect",
			},

			preselect = cmp.PreselectMode.None,

			-- For an understanding of why these mappings were
			-- chosen, you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),

				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion.
				-- This will auto-import if your LSP supports it.
				-- This will also expand snippets sent by the LSP.
				["<C-y>"] = cmp.mapping.confirm({
					select = true,
				}),

				-- If you prefer more traditional completion keymaps,
				-- you can uncomment the following line.
				-- ["<CR>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				-- Generally you don't need this, because nvim-cmp will display
				-- completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete(),

				-- Move forward through placeholders of an expanded LSP snippet.
				["<C-l>"] = cmp.mapping(function(fallback)
					if vim.snippet.active({ direction = 1 }) then
						vim.snippet.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Move backwards through placeholders of an expanded LSP snippet.
				["<C-h>"] = cmp.mapping(function(fallback)
					if vim.snippet.active({ direction = -1 }) then
						vim.snippet.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Select next item with Tab.
				-- If a snippet is active, jump to its next placeholder.
				-- Otherwise preserve the normal Tab behavior.
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({
							behavior = cmp.SelectBehavior.Select,
						})
					elseif vim.snippet.active({ direction = 1 }) then
						vim.snippet.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Select previous item with Shift + Tab.
				-- If a snippet is active, jump to its previous placeholder.
				-- Otherwise preserve the normal Shift + Tab behavior.
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({
							behavior = cmp.SelectBehavior.Select,
						})
					elseif vim.snippet.active({ direction = -1 }) then
						vim.snippet.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = {
				{
					name = "lazydev",
					-- Set group index to 0 to skip loading LuaLS completions
					-- as lazydev recommends it.
					group_index = 0,
				},

				-- Completion items returned by the active LSP.
				{ name = "nvim_lsp" },

				-- Words already present in the current buffer.
				{ name = "buffer" },

				-- Filesystem paths.
				{ name = "path" },
			},

			formatting = {
				fields = { "kind", "abbr", "menu" },

				format = function(entry, vim_item)
					-- Replace completion kind text with Nerd Font icons.
					vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind

					-- Show where each completion candidate came from.
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]

					return vim_item
				end,
			},
		})
	end,
}
