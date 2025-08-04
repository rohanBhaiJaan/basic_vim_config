syntax on
set nocompatible 
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set autoindent smartindent
set noswapfile

let mapleader = ' '
let g:netrw_keepdir = 0
let g:netrw_winsize = 30

call plug#begin()

call plug#end()

nnoremap <leader>s :split
nnoremap <leader>ee :Lexplore<CR>
nnoremap <leader>ec :Lexplore %:p:h<CR>

nnoremap <leader>t :below terminal<CR>
