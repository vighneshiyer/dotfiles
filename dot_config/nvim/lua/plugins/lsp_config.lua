return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = false, -- Disable pyright
        ty = {
          filetypes = { "python" },
        },
      },
    },
  },
}
