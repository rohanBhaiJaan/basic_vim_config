if has("syntax")
  syntax on
endif

let mapleader = ' '
packloadall

set nocompatible 
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set autoindent smartindent
set noswapfile nowrap
set termguicolors
set hidden
set path+=* tags=./tags;/
set encoding=utf-8 fileencoding=utf-8
set scrolloff=12

let g:netrw_winsize = 35
let g:tokyonight_style = 'night'

" let g:be_vimmer_enable = 1
" let g:be_vimmer_insert_mode_deletion = 1
" let g:be_vimmer_wait_time = 1000 

colorscheme gruvbox

command! ShowChangeBuf :call utils#functions#ShowChangeBuf()
command! ChangeBuf :call utils#functions#ChangeBuf()

augroup NETRW
  autocmd!
  autocmd VimEnter * if isdirectory(argv(0)) | let g:ExploreBufNo = bufnr(argv(0)) | endif
augroup END

augroup NUMBERS
  autocmd!
  autocmd FILETYPE netrw setlocal nu rnu
  autocmd FILETYPE help setlocal nu rnu
augroup END

colorscheme mytheme

" let &runtimepath = &runtimepath . ',' . $HOME . '/projects/core_plugins/vim_practice.vim/'
