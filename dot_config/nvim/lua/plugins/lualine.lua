return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- index 4 is LazyVim's pretty_path component in lualine_c
    opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 4 }) }
  end,
}
