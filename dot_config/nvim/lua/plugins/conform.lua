return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "rust" then
          return false
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
    },
  },
}
