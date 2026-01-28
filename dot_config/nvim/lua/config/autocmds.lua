-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Autocommands for setting syntax based on file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.sv", "*.v", "*.vh" },
  callback = function()
    vim.bo.syntax = "verilog"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Makefrag",
  callback = function()
    vim.bo.syntax = "make"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "SConscript", "SConstruct" },
  callback = function()
    vim.bo.syntax = "python"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.lib",
  callback = function()
    vim.bo.syntax = "text"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.sbt", "*.sc" },
  callback = function()
    vim.bo.filetype = "scala"
  end,
})

-- Disable indentexpr for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.bo.indentexpr = ""
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "htmldjango", "jinja" },
  callback = function()
    vim.bo.indentexpr = ""
  end,
})

-- Disable 'conceals' for Markdown
-- I don't like how code block markers are concealed
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Disable autoformat for Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Automatically send SIGWINCH signal on VimEnter event
-- This notifies the terminal emulator about window size changes when Vim starts
-- It fixes some minor bugs in i3's windowing
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.fn.system("kill -s SIGWINCH $PPID")
  end,
})
