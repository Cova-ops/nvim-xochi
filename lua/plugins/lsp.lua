return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",

		-- Better TS/JS LSP experience than plain tsserver
		"pmizio/typescript-tools.nvim",

		-- JSON/YAML schemas
		"b0o/schemastore.nvim",
	},
	config = function()
		-- LspAttach mappings + UX
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gvd", function()
					require("telescope.builtin").lsp_definitions({
						jump_type = "vsplit",
					})
				end, "[G]oto [V]ertical [D]efinition")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- highlight references under cursor
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- inlay hints toggle
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					local bufnr = event.buf
					map("<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- capabilities (cmp)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- typescript-tools (se maneja aparte, NO via mason-lspconfig handlers)
		require("typescript-tools").setup({
			capabilities = capabilities,
			settings = {
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		})

		-- Diagnostics (Neovim 0.11+)
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Servers via lspconfig + mason-lspconfig
		local servers = {
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						procMacro = { enable = true },
						cargo = { buildScripts = { enable = true } },
						checkOnSave = { command = "clippy" },
						inlayHints = {
							enable = true,
							typeHints = { enable = true },
							parameterHints = { enable = true },
							chainingHints = { enable = true },
						},
					},
				},
			},

			taplo = {}, -- .toml

			-- ESLint como LSP (diagnósticos + code actions)
			eslint = {
				settings = { format = false },
			},

			emmet_ls = {
				filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
			},

			cssmodules_ls = {},

			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {},

			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},

			yamlls = {
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},

			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},

			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = { enable = false },
					},
				},
			},
		}

		require("mason").setup()

		require("mason-lspconfig").setup({

			-- IMPORTANTE: no metas ts_ls aquí, lo maneja typescript-tools
			handlers = {
				function(server_name)
					-- -- 🔥 Bloquea TS LSP duplicado (typescript-tools ya lo maneja)
					-- if server_name == "ts_ls" or server_name == "tsserver" then
					-- 	return
					-- end

					local server = servers[server_name]
					if not server then
						return
					end

					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- Mantén esto solo si quieres formato específico TOML (taplo).
		-- Ojo: si tu none-ls hace format-on-save global, este autocmd es extra.
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.toml",
			callback = function()
				vim.lsp.buf.format({
					timeout_ms = 1000,
					filter = function(client)
						return client.name == "taplo"
					end,
				})
			end,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.rs",
			callback = function(args)
				vim.lsp.buf.format({
					async = false,
					bufnr = args.buf,
					timeout_ms = 2000,
					filter = function(client)
						return client.name == "rust_analyzer"
					end,
				})
			end,
		})

		-- (opcional) keymap para correr fix all de eslint rápido
		vim.keymap.set("n", "<leader>ef", "<cmd>EslintFixAll<cr>", { desc = "ESLint: Fix all" })
	end,
}
