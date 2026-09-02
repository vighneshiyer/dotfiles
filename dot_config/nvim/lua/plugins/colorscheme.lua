return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "night",
    -- diff.add derives from green2 (#41a6b5), which is teal, not green. Realign both
    -- to delta's dark defaults so vim diff mode and the CLI pager agree.
    -- on_colors runs after colors.diff is built, so every consumer of it picks this up
    on_colors = function(c)
      c.diff.add = "#002800"
      c.diff.delete = "#3f0001"
    end,
  },
}
