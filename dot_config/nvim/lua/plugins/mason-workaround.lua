return {
  {
    "mason-org/mason.nvim",
    --version = "1.11.0",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "black",
        "pyright",
        "rust-analyzer",
        "lua-language-server",
        "marksman",
        "tinymist",
      },
    },
  },
  --{ "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
}
