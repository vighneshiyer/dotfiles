-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map semi-colon to colon to make commands easy to run
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true, silent = false })

-- Tab switching mappings
vim.api.nvim_set_keymap("n", "<Leader><Tab>1", "1gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>2", "2gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>3", "3gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>4", "4gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>5", "5gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>6", "6gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>7", "7gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>8", "8gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>9", "9gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Tab>0", "10gt", { noremap = true, silent = true })

-- Remove all trailing whitespace by pressing F5
vim.api.nvim_set_keymap(
  "n",
  "<F5>",
  [[:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]],
  { noremap = true, silent = true }
)

-- Disable ex mode
vim.api.nvim_set_keymap("n", "Q", "<Nop>", { noremap = true, silent = true })
