syntax on
set nocompatible 
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set autoindent smartindent
set noswapfile
set termguicolors
set hidden
set path+=*

let mapleader = ' '
let g:netrw_keepdir = 0
let g:netrw_winsize = 35
let g:tokyonight_style = 'night'
let g:netrw_liststyle = 3

call plug#begin()
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'bfrg/vim-c-cpp-modern'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-surround'
call plug#end()

colorscheme tokyonight

nnoremap <leader>s :split
nnoremap <leader>ee :Lexplore<CR>
nnoremap <leader>ec :Lexplore %:p:h<CR>

nnoremap <leader>t :below terminal<CR>
nnoremap <leader>b :call ChangeBuf()<CR>

function! ChangeBuf()
  let bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  echo "Enter the index of Buffer: "
  let index = str2nr(nr2char(getchar()))
  if index > 0 && index <= len(bufs)
    execute 'buffer ' . bufs[index - 1].bufnr
  else
    echoerr 'Invalid Index'
  endif
endfunction
