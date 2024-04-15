return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "black",
      "pyright",
      "ruff-lsp",
      "rust-analyzer",
      "lua-language-server",
      "marksman",
    },
  },
}
