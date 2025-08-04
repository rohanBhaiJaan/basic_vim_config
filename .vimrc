syntax on
set nocompatible 
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set autoindent smartindent
set noswapfile
set termguicolors

let mapleader = ' '
let g:netrw_keepdir = 0
let g:netrw_winsize = 30
let g:tokyonight_style = 'night'

call plug#begin()
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'bfrg/vim-c-cpp-modern'
call plug#end()

colorscheme tokyonight

nnoremap <leader>s :split
nnoremap <leader>ee :Lexplore<CR>
nnoremap <leader>ec :Lexplore %:p:h<CR>

nnoremap <leader>t :below terminal<CR>
