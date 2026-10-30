-- Clear Dark - macOS Terminal.app inspired theme

vim.cmd("highlight clear")
vim.g.colors_name = "clear-dark"
vim.o.termguicolors = true
vim.o.background = "dark"

local c = {
	bg = "#222733",
	fg = "#E0E0E0",

	black = "#35424C",
	bright_black = "#465C6D",

	red = "#B45648",
	bright_red = "#DF6C5A",

	green = "#6CAA71",
	bright_green = "#79BE7E",

	yellow = "#C4AC62",
	bright_yellow = "#E5C872",

	blue = "#6D96B4",
	bright_blue = "#67B5ED",

	magenta = "#BD7BCD",
	bright_magenta = "#D389E5",

	cyan = "#7CCBCD",
	bright_cyan = "#84DDE0",

	white = "#DEE5EB",
	bright_white = "#E5EFF5",

	selection = "#273C4C",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal", { fg = c.fg, bg = "NONE" })
hl("NormalNC", { fg = c.fg, bg = "NONE" })
hl("NormalFloat", { fg = c.fg, bg = c.bg })
hl("FloatBorder", { fg = c.bright_black, bg = c.bg })

hl("CursorLine", { bg = "#2C3441" })
hl("CursorLineNr", { fg = c.yellow, bold = true })
hl("LineNr", { fg = c.bright_black })
hl("SignColumn", { bg = "NONE" })
hl("ColorColumn", { bg = "#2C3441" })

hl("Visual", { bg = c.selection })
hl("Search", { fg = c.bg, bg = c.yellow })
hl("IncSearch", { fg = c.bg, bg = c.bright_yellow })
hl("MatchParen", { fg = c.bright_cyan, bold = true })

hl("StatusLine", { fg = c.fg, bg = "#303947" })
hl("StatusLineNC", { fg = c.bright_black, bg = c.bg })
hl("WinSeparator", { fg = c.black })

hl("Pmenu", { fg = c.fg, bg = "#303947" })
hl("PmenuSel", { fg = c.bg, bg = c.blue })

-- Syntax
hl("Comment", { fg = c.bright_black, italic = true })

hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.yellow })
hl("Boolean", { fg = c.yellow })
hl("Float", { fg = c.yellow })

hl("Function", { fg = c.blue })
hl("Identifier", { fg = c.fg })
hl("Keyword", { fg = c.magenta })
hl("Statement", { fg = c.magenta })
hl("Conditional", { fg = c.magenta })
hl("Repeat", { fg = c.magenta })

hl("Type", { fg = c.cyan })
hl("Structure", { fg = c.cyan })
hl("Constant", { fg = c.yellow })
hl("Operator", { fg = c.fg })
hl("PreProc", { fg = c.magenta })
hl("Special", { fg = c.bright_red })

-- Treesitter
hl("@comment", { link = "Comment" })
hl("@string", { link = "String" })
hl("@number", { link = "Number" })
hl("@boolean", { link = "Boolean" })

hl("@function", { link = "Function" })
hl("@function.call", { fg = c.blue })
hl("@function.method", { fg = c.blue })

hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { fg = c.magenta })
hl("@keyword.return", { fg = c.magenta })

hl("@type", { link = "Type" })
hl("@type.builtin", { fg = c.cyan })

hl("@variable", { fg = c.fg })
hl("@variable.parameter", { fg = c.bright_white })

hl("@property", { fg = c.cyan })
hl("@constant", { fg = c.yellow })

-- Diagnostics
hl("DiagnosticError", { fg = c.bright_red })
hl("DiagnosticWarn", { fg = c.bright_yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.cyan })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })

-- Git
hl("DiffAdd", { fg = c.green })
hl("DiffChange", { fg = c.blue })
hl("DiffDelete", { fg = c.red })

-- Terminal colors
local terminal_colors = {
	c.black,
	c.red,
	c.green,
	c.yellow,
	c.blue,
	c.magenta,
	c.cyan,
	c.white,
	c.bright_black,
	c.bright_red,
	c.bright_green,
	c.bright_yellow,
	c.bright_blue,
	c.bright_magenta,
	c.bright_cyan,
	c.bright_white,
}

for i, color in ipairs(terminal_colors) do
	vim.g["terminal_color_" .. (i - 1)] = color
end
