-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Autocommands for setting syntax based on file types
vim.api.nvim_exec(
  [[
  autocmd BufRead,BufNewFile *.v set syntax=verilog
  autocmd BufRead,BufNewFile *.vh set syntax=verilog
  autocmd BufRead,BufNewFile Makefrag set syntax=make
  autocmd BufRead,BufNewFile SConscript set syntax=python
  autocmd BufRead,BufNewFile SConstruct set syntax=python
  autocmd BufRead,BufNewFile *.lib set syntax=text
  autocmd BufRead,BufNewFile *.sbt,*.sc set filetype=scala
  autocmd FileType tex setlocal indentexpr=
  autocmd FileType html,htmldjango,jinja setlocal indentexpr=
]],
  false
)

-- Automatically send SIGWINCH signal on VimEnter event
-- This notifies the terminal emulator about window size changes when Vim starts
-- It fixes some minor bugs in i3's windowing
vim.api.nvim_exec(
  [[
  autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
]],
  false
)
