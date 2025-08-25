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

" call plug#begin()
"   Plug 'ghifarit53/tokyonight-vim'
"   Plug 'bfrg/vim-c-cpp-modern'
"   Plug 'vim-airline/vim-airline'
"   Plug 'tpope/vim-surround'
"   Plug 'tpope/vim-commentary'
"   Plug 'vimwiki/vimwiki'
" call plug#end()

colorscheme tokyonight

nnoremap <leader>ff :find 
xnoremap <silent> <leader>p :call GetVisualModeContent()<CR>

nnoremap <leader>e :call utils#functions#ToggleNetrw()<CR>
nnoremap <leader>E :Explore %:p:h<CR>

nnoremap <leader>b :ChangeBuf<CR>
nnoremap <leader>x :so%<CR>

"WINDOW KEY REMAPS
nnoremap + <C-w>+
nnoremap - <C-w>-

command! ShowBuf :call utils#functions#ShowBuf()
command! ChangeBuf :call utils#functions#ChangeBuf()
command! Tags :call system("ctags -R .")

augroup NETRW
  autocmd!
  autocmd VimEnter * if isdirectory(argv(0)) | let g:ExploreBufNo = bufnr(argv(0)) | endif
augroup END

colorscheme mytheme

" let &runtimepath = &runtimepath . ',' . $HOME . '/projects/vim_practice.vim/'
