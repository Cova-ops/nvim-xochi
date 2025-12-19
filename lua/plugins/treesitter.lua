return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "master",
	event = { "BufReadPost", "BufNewFile" },


	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		"windwp/nvim-ts-autotag",
		"andymass/vim-matchup",
	},

	init = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldenable = true
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldcolumn = "0"

		_G.custom_fold_text = function()
			return vim.fn.getline(vim.v.foldstart) .. " …"
		end
		vim.opt.foldtext = "v:lua.custom_fold_text()"
	end,

	opts = {
		ensure_installed = {
			"bash",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"rust",
			"javascript",
			"python",
			"typescript",
			"go",
			"c",
			"cpp",
			"css",
			"tsx",
		},
		auto_install = true,

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		indent = { enable = true },

		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
			},
		},

		matchup = { enable = true },
		autotag = { enable = true },
	},
}
-- ===========================================================
-- 📘 COMANDOS DE FOLD EN NEOVIM
-- ===========================================================
--
-- 🔹 CREAR FOLDS
-- zf{movimiento}     → Crea un fold manual desde la posición actual
-- zf%                → Crea un fold del bloque actual (usa el par de llaves)
-- zf}                → Crea un fold hasta la siguiente llave de cierre
-- zfG                → Crea un fold hasta el final del archivo
--
-- 🔹 ABRIR / CERRAR FOLDS
-- zo                 → Abre el fold bajo el cursor (unfold)
-- zO                 → Abre el fold bajo el cursor y todos los subfolds dentro
-- zc                 → Cierra el fold bajo el cursor
-- zC                 → Cierra el fold bajo el cursor y todos los subfolds dentro
-- za                 → Alterna (abre/cierra) el fold bajo el cursor
--
-- 🔹 ABRIR / CERRAR TODOS LOS FOLDS
-- zR                 → Abre TODOS los folds del archivo
-- zM                 → Cierra TODOS los folds del archivo
--
-- 🔹 NAVEGACIÓN ENTRE FOLDS
-- zj                 → Salta al siguiente fold
-- zk                 → Salta al fold anterior
-- [z                 → Salta al inicio del fold actual
-- ]z                 → Salta al final del fold actual
--
-- 🔹 MANEJO AVANZADO
-- zd                 → Elimina el fold bajo el cursor
-- zD                 → Elimina todos los folds anidados bajo el cursor
-- zE                 → Elimina TODOS los folds manuales del archivo
-- zm                 → Incrementa el nivel de plegado (muestra menos)
-- zr                 → Disminuye el nivel de plegado (muestra más)
-- zn                 → Desactiva temporalmente el plegado (muestra todo)
-- zN                 → Reactiva el plegado normal
-- zi                 → Alterna entre activar/desactivar el plegado
--
-- 🔹 OPCIONES ÚTILES EN EL init.vim / init.lua
-- set foldmethod=expr           → Usa expresiones (por ejemplo, Tree-sitter)
-- set foldexpr=nvim_treesitter#foldexpr()
-- set foldenable                → Activa el plegado por defecto
-- set foldlevel=99              → Evita que todo se abra plegado
-- set foldlevelstart=99         → Define el nivel inicial de apertura
-- set foldcolumn=1              → Muestra una columna visual para folds
--
-- ===========================================================
-- 📎 CONSEJO:
--  - Usa `zf%` estando en la primera línea de una función para plegarla completa.
--  - Usa `zo` para abrir y `zc` para cerrar.
--  - Usa `zR` para abrir todo y `zM` para cerrarlo todo.
-- ===========================================================
