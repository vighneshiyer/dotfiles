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

-- Leader + m = run make
vim.api.nvim_set_keymap("n", "<Leader>m", ":make<CR>", { noremap = true, silent = true, desc = "Run make" })

-- https://myriad-dreamin.github.io/tinymist/frontend/neovim.html#label-Working%20with%20Multiple-Files%20Projects
require("lspconfig")["tinymist"].setup({
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<leader>tp", function()
      client:exec_cmd({
        title = "pin",
        command = "tinymist.pinMain",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [P]in", noremap = true })
    vim.keymap.set("n", "<leader>tu", function()
      client:exec_cmd({
        title = "unpin",
        command = "tinymist.pinMain",
        arguments = { vim.v.null },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [U]npin", noremap = true })
  end,
})
