return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
  opts = {
    ensure_installed = {
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
    },
    auto_install = true,
  },
}
