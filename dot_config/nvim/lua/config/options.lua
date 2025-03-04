-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Highlight text that exceeds 100 columns in length
-- vim.api.nvim_exec(
--   [[
--    highlight ColorColumn ctermbg=0 guibg=#282828
--    let &colorcolumn="100,"..join(range(130,999),",")
--  ]],
--   false
-- )

-- Show characters for expanded TABs, trailing whitespace, and end-of-lines
-- if vim.o.listchars == 'eol:$' then
--    vim.o.listchars = 'tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+'
-- end
-- vim.o.list = true -- Show problematic characters

-- Highlight all tabs and trailing whitespace characters
-- vim.api.nvim_exec(
--   [[
--    highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
--    match ExtraWhitespace /\s\+$\|\t/
--  ]],
--   false
-- )
-- Use bigger unicode characters to separate windows
vim.opt.fillchars = {
  horiz = "▬", -- normally '─', bold "━"
  horizup = "█", -- normally '┴', bold "┻"
  horizdown = "█", -- normally '┬', bold "┳"
  vert = "█", -- normally '│'
  vertleft = "█", -- normally '┤', bold "┫"
  vertright = "█", -- normally '├', bold "┣"
  verthoriz = "█", -- normally '┼', bold "╋"
}
vim.g.snacks_animate = false
