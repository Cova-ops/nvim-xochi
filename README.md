🧠 Neovim Configuration (Lazy.nvim + Mason + LSP + Treesitter)

This repository contains my personal Neovim configuration, focused on:

- ⚡ Fast startup with lazy.nvim
- 🧩 Clear separation of LSP, formatters, and linters
- 🌳 Heavy use of Tree-sitter (highlighting, textobjects, folds)
- 🛠️ Modern tooling via Mason
- 🧼 Predictable, debuggable setup (no magic auto-installs)

The config is designed to be stable across Neovim updates and easy to reason about.

---

✨ Features

🚀 Plugin Manager

- lazy.nvim
- No legacy packer.nvim
- Explicit plugin boundaries

🧠 LSP (Language Server Protocol)

- Managed via mason.nvim + mason-lspconfig.nvim
- Only real LSP servers are configured (no formatters masquerading as LSPs)
- Custom on_attach, keymaps, inlay hints, highlights

Supported languages (non-exhaustive):

- Rust (rust-analyzer)
- Lua (lua_ls)
- TypeScript / JavaScript (typescript-tools)
- Python (pylsp, ruff)
- HTML / CSS / Tailwind
- SQL, Terraform, Docker, YAML, JSON

🎨 Formatting & Linting

- none-ls.nvim (successor of null-ls)
- mason-null-ls.nvim installs only CLI tools

Examples:

- stylua (Lua formatting)
- prettier (JS/HTML/Markdown)
- ruff (Python lint + format)
- shfmt, checkmake, etc.

⚠️ Important design rule: formatters are never treated as LSP servers.

---

🌳 Tree-sitter

Tree-sitter is a core part of this setup:

- Syntax highlighting
- Indentation
- Textobjects
- Folding (Tree-sitter based)

Folding Strategy

foldmethod = expr
foldexpr = vim.treesitter.foldexpr()
foldlevel = 99

Folds work reliably for:

- Rust
- Lua
- JS / TS
- Python

Requires tree-sitter-cli installed on the system.

---

🗂️ Project Structure

```
~/.config/nvim
├── init.lua
├── lua/
│   ├── plugins/
│   │   ├── lsp.lua          # LSP + mason-lspconfig
│   │   ├── none-ls.lua      # Formatting / linting
│   │   ├── treesitter.lua   # Treesitter + folds
│   │   ├── ui.lua           # Statusline, notifications
│   │   ├── telescope.lua
│   │   └── ...
│   └── utils/
│       └── sysinfo.lua      # CPU/RAM for lualine
```

Each concern lives in exactly one file.

---

📊 UI Enhancements

- lualine.nvim
- CPU & RAM usage with icons
- Dynamic colors based on load
- fidget.nvim for LSP progress
- which-key.nvim
- neo-tree.nvim file explorer
- telescope.nvim fuzzy finding

---

🧪 Health & Stability

This setup is regularly validated with:

```vim
:Lazy
:checkhealth
:Mason
:TSUpdate
```

Deprecations are intercepted using vim.deprecate to surface warnings early.

---

🧰 System Requirements

- Neovim >= 0.11
- Git
- Node.js (for some LSPs)
- Python 3 (optional)
- Rust toolchain (for rust-analyzer)

macOS (recommended installs)

brew install neovim
brew install tree-sitter-cli
brew install ripgrep fd

---

❗ Design Decisions

- ❌ No auto-install magic for LSPs
- ❌ No formatters as LSPs (e.g. stylua --lsp)
- ❌ No duplicated Mason setup
- ✅ Explicit > implicit
- ✅ Debuggable > clever

This avoids subtle bugs during upgrades.

---

📌 Inspiration

- kickstart.nvim (structure ideas)
- Neovim core documentation
- Mason / Tree-sitter best practices

---

📜 License

MIT — feel free to copy, fork, or adapt.

---

If you use this config and break Neovim, that’s on you 😄
