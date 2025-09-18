if has("syntax")
  syntax on
endif

if v:version >= 901
  packadd hlyank
  packadd comment
endif

let mapleader = ' '
packadd be-vimmer

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
set background=dark

" STATUSLINE
set statusline=%f
set statusline+=\ %y
set statusline+=%m

let g:netrw_winsize = 35
let g:netrw_banner = 0
let g:hlyank_duration = 100

let g:tokyonight_style = 'night'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_foreground = 'mix'

colorscheme gruvbox-material

if exists("g:be_vimmer")
  call be_vimmer#Setup(1, 1000)
endif

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

let &runtimepath = &runtimepath . ',' . $HOME . '/projects/core_plugins/vim_practice.vim/'
" let &runtimepath = &runtimepath . ',' . $HOME . '/projects/showlongline'
