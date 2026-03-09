return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = false, -- Disable pyright
        ty = {
          filetypes = { "python" },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                buildScripts = { enable = true },
              },
              procMacro = { enable = true },
            },
          },
        },
      },
    },
  },
}
