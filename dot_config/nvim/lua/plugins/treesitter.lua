return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "python",
      "cpp",
      "scala",
      "verilog",
      "latex",
      "toml",
      "markdown",
      "markdown_inline",
    },
  },
}
