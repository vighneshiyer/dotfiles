return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    opts["sources"] = nil
    opts["sources"] = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
    })
  end,
}
