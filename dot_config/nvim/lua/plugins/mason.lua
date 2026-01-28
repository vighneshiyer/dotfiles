return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "rust-analyzer",
        "lua-language-server",
        "marksman",
        "tinymist",
        "ty",
      },
    },
  },
}
