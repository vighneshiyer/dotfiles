set shell=/bin/bash

call plug#begin('~/.local/share/nvim/plugged')
" Color theme
Plug 'morhetz/gruvbox'
" Status bar
Plug 'vim-airline/vim-airline'
" Sensible vim defaults
Plug 'tpope/vim-sensible'
" Automatically detect tab size for files
Plug 'tpope/vim-sleuth'
" Directory browser
Plug 'preservim/nerdtree'
" LaTeX syntax highlighting
Plug 'lervag/vimtex'
" Markdown syntax highlighting
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
" SMT2 syntax highlighting
"Plug 'bohlender/vim-smt2'
" Jinja2 syntax highlighting
"Plug 'Glench/Vim-Jinja2-Syntax'
call plug#end()

" Use spacebar as leader key
let mapleader="\<SPACE>"
" Use Latex indenting style
let g:tex_flavor='latex'
set nocompatible
set mouse=a

" activates filetype detection
"filetype plugin indent on

" activates syntax highlighting among other things
syntax on
syntax enable

" allows you to deal with multiple unsaved
" buffers simultaneously without resorting
" to misusing tabs
set hidden

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set showcmd         " Show command in statusline
set showmatch       " Show matching brackets
set showmode        " Show current mode
set splitbelow      " Hori split on bottom
set splitright      " Vert split on right

if !&scrolloff
  set scrolloff=3   " Show next 3 lines when scrolling
endif
if !&sidescrolloff
  set sidescrolloff=5 " Show next 5 columns when side-scrolling
endif
set nostartofline   " Don't jump to first character with page commands

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
set ignorecase      " Make searching case insensitive
set smartcase       " ... unless the query has capital letters
set gdefault        " use global flag by default when search/replace
set magic           " extended regex when searching

set laststatus=2
set ruler
set wildmenu

set termguicolors
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
colorscheme gruvbox
set number

" this turns off physical line wrapping (automatic insertion of newlines)
set textwidth=0
set wrapmargin=0
set tw=0
set formatoptions-=t " do not automatically wrap text when typing

" this highlights text that exceeds 100 columns in length to evaluate breaking more text into new lines
highlight ColorColumn ctermbg=0 guibg=#282828
let &colorcolumn="100,".join(range(130,999),",")

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Use relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

"""" Special commands/shortcuts
nmap <Leader>s :%s//<Left>
nnoremap <Leader>r :call NumberToggle()<cr>
nnoremap ; :
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>

vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap <Leader>h <C-w>h
nmap <Leader>j <C-w>j
nmap <Leader>k <C-w>k
nmap <Leader>l <C-w>l
nmap <Leader>c <C-w>c

"" tab switching
nmap <Leader>1 1gt
nmap <Leader>2 2gt
nmap <Leader>3 3gt
nmap <Leader>4 4gt
nmap <Leader>5 5gt
nmap <Leader>6 6gt
nmap <Leader>7 7gt
nmap <Leader>8 8gt
nmap <Leader>9 9gt
nmap <Leader>0 10gt

nnoremap <Leader>n :NERDTreeToggle<CR>

nnoremap <Leader>m :make<CR>
autocmd BufRead,BufNewFile *.v set syntax=verilog
autocmd BufRead,BufNewFile *.vh set syntax=verilog
autocmd BufRead,BufNewFile Makefrag set syntax=make
autocmd BufRead,BufNewFile SConscript set syntax=python
autocmd BufRead,BufNewFile SConstruct set syntax=python
autocmd BufRead,BufNewFile *.lib set syntax=text
autocmd BufRead,BufNewFile *.sbt,*.sc set filetype=scala
autocmd FileType tex setlocal indentexpr=
autocmd FileType html,htmldjango,jinja setlocal indentexpr=

" folding
set foldmethod=syntax
set foldnestmax=10
set nofoldenable " don't enable folds after opening a file
set foldlevel=2
let g:markdown_folding = 1

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" disable ex mode
nnoremap Q <Nop>

autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
