vim.o.shell = '/bin/bash'

-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_var('mapleader', ' ') -- Use spacebar as leader key

require("lazy").setup({
  "morhetz/gruvbox",          -- Color theme
  "vim-airline/vim-airline",  -- Status bar
  "tpope/vim-sensible",       -- Sensible vim defaults
  "tpope/vim-sleuth",         -- Automatically detect tab size for files
  "preservim/nerdtree",       -- Directory browser
  "godlygeek/tabular",        -- Alignment
  "preservim/vim-markdown",   -- Markdown syntax highlighting
  -- "bohlender/vim-smt2",    -- SMT2 syntax highlighting
  "Glench/Vim-Jinja2-Syntax", -- Jinja2 syntax highlighting
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}, -- Treesitter syntax highlighting
  {"nvim-telescope/telescope.nvim", tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } }, -- File/phrase searcher + previewer
  {"nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
  {"nvim-telescope/telescope-live-grep-args.nvim" , tag = 'v1.0.0' },
  "tpope/vim-repeat", -- support repeating plugin commands with '.'
  -- "ggandor/leap.nvim"
  "nvim-tree/nvim-tree.lua"
})

require("nvim-tree").setup()

vim.g.tex_flavor = 'latex'  -- Use Latex indenting style
vim.o.mouse = 'a'           -- Enable mouse support in 'a'll modes
vim.cmd('syntax on')        -- Activate syntax highlighting
vim.cmd('syntax enable')
vim.o.hidden = true         -- Allows you to switch between buffers without saving changes
vim.o.autoindent = true     -- Enable auto-indentation
vim.o.backspace = 'indent,eol,start' -- Define backspace behavior
-- vim.o.complete:remove('i') -- Disable insert-mode completion
vim.o.smarttab = true       -- Enable smart tab behavior
vim.o.expandtab = true      -- Expand tabs to spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.showcmd = true        -- Show command in statusline
vim.o.showmatch = true      -- Show matching brackets
vim.o.showmode = true       -- Show current mode
vim.o.splitbelow = true     -- Horizontal split below
vim.o.splitright = true     -- Vertical split on the right
vim.wo.number = true        -- Show line numbers

if vim.o.scrolloff == 0 then
    vim.o.scrolloff = 3     -- Show next 3 lines when scrolling
end

if vim.o.sidescrolloff == 0 then
    vim.o.sidescrolloff = 5 -- Show next 5 columns when side scrolling
end

vim.o.startofline = false   -- Disable jump to first character with page commands
vim.o.incsearch = true      -- Enable incremental search

-- Use <C-L> to clear highlighting of :set hlsearch
if vim.fn.maparg('<C-L>', 'n') ==# '' then
    vim.api.nvim_set_keymap('n', '<C-L>', [[:nohlsearch<CR>:silent! diffupdate<CR><C-L>]], { noremap = true, silent = true })
end

vim.o.ignorecase = true     -- Make searching case insensitive
vim.o.smartcase = true      -- Make searching case sensitive if the query has capital letters
vim.o.gdefault = true       -- Use global flag by default when search/replace
vim.o.magic = true          -- Enable magic (extended regex) when searching
vim.o.laststatus = 2        -- Set laststatus to 2 (always show statusline)
vim.o.ruler = true          -- Show ruler
vim.o.wildmenu = true       -- Enable wildmenu for better command-line completion experience
vim.o.termguicolors = true  -- Set terminal to use true colors
vim.o.background = 'dark'   -- Set background to dark

-- Gruvbox configuration
vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_contrast_light = 'hard'
vim.cmd('colorscheme gruvbox') -- Load Gruvbox colorscheme

-- Turn off physical line wrapping (automatic insertion of newlines)
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.tw = 0
vim.o.formatoptions = vim.o.formatoptions:gsub('t', '')

-- Highlight text that exceeds 100 columns in length
vim.api.nvim_exec([[
  highlight ColorColumn ctermbg=0 guibg=#282828
  let &colorcolumn="100,"..join(range(130,999),",")
]], false)

-- Show characters for expanded TABs, trailing whitespace, and end-of-lines
-- if vim.o.listchars == 'eol:$' then
--    vim.o.listchars = 'tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+'
-- end
vim.o.list = true  -- Show problematic characters

-- Highlight all tabs and trailing whitespace characters
vim.api.nvim_exec([[
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  match ExtraWhitespace /\s\+$\|\t/
]], false)

-- Use relative numbering
function NumberToggle()
    if vim.o.relativenumber == true then
        vim.o.relativenumber = false
        vim.o.number = true
    else
        vim.o.relativenumber = true
    end
end

-- Leader shortcuts
-- vim.api.nvim_set_keymap('n', '<Leader>s', ':%s//<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>r', ':lua NumberToggle()<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true, silent = false})
vim.api.nvim_set_keymap('n', '<Leader>q', ':wq<CR>', { noremap = true, silent = false})

-- Clipboard mappings for yank, delete, and paste to system clipboard
vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', { noremap = true, silent = false  })
vim.api.nvim_set_keymap('v', '<Leader>d', '"+d', { noremap = true, silent = false  })
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true, silent = false  })
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', { noremap = true, silent = false  })
vim.api.nvim_set_keymap('v', '<Leader>p', '"+p', { noremap = true, silent = false  })
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', { noremap = true, silent = false  })

-- Window navigation mappings, vim style movement, 'c' to close
vim.api.nvim_set_keymap('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>c', '<C-w>c', { noremap = true, silent = true })

-- Tab switching mappings
vim.api.nvim_set_keymap('n', '<Leader>1', '1gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>2', '2gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>3', '3gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>4', '4gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>5', '5gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>6', '6gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>7', '7gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>8', '8gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>9', '9gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>0', '10gt', { noremap = true, silent = true })

-- Buffer switching mappings
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- Mapping Leader+n to NERDTreeToggle
vim.api.nvim_set_keymap('n', '<Leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.g.NERDTreeShowHidden = 1

-- Mapping Leader+m to :make<CR>
vim.api.nvim_set_keymap('n', '<Leader>m', ':make<CR>', { noremap = true, silent = true })

-- Autocommands for setting syntax based on file types
vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.v set syntax=verilog
  autocmd BufRead,BufNewFile *.vh set syntax=verilog
  autocmd BufRead,BufNewFile Makefrag set syntax=make
  autocmd BufRead,BufNewFile SConscript set syntax=python
  autocmd BufRead,BufNewFile SConstruct set syntax=python
  autocmd BufRead,BufNewFile *.lib set syntax=text
  autocmd BufRead,BufNewFile *.sbt,*.sc set filetype=scala
  autocmd FileType tex setlocal indentexpr=
  autocmd FileType html,htmldjango,jinja setlocal indentexpr=
]], false)

-- Folding settings
vim.o.foldmethod = 'syntax'
vim.o.foldnestmax = 10
vim.o.foldenable = false  -- Don't enable folds after opening a file
vim.o.foldlevel = 2
vim.g.markdown_folding = 1

-- Remove all trailing whitespace by pressing F5
vim.api.nvim_set_keymap('n', '<F5>', [[:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]], { noremap = true, silent = true })

-- Disable ex mode
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', { noremap = true, silent = true })

-- Automatically send SIGWINCH signal on VimEnter event
-- This notifies the terminal emulator about window size changes when Vim starts
-- It fixes some minor bugs in i3's windowing
vim.api.nvim_exec([[
  autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
]], false)

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "cpp", "scala", "verilog", "latex", "toml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript", "markdown", "markdown_inline" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('telescope').setup {
  defaults = {
      --file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      --grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      --qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
      file_previewer = require'telescope.previewers'.cat.new,
      grep_previewer = require'telescope.previewers'.vimgrep.new,
      qflist_previewer = require'telescope.previewers'.qflist.new,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
    }
  },
  pickers = {
    find_files = {
      follow = true
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set("n", "<leader>g", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>s', builtin.grep_string, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- require('leap').add_default_mappings(true)
