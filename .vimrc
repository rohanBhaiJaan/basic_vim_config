syntax on
set nocompatible 
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set autoindent smartindent
set noswapfile
set nowrap
set termguicolors
set hidden
set path+=*

let mapleader = ' '
let g:netrw_keepdir = 0
let g:netrw_winsize = 35
let g:tokyonight_style = 'night'

call plug#begin()
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'bfrg/vim-c-cpp-modern'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'vimwiki/vimwiki'
call plug#end()

colorscheme tokyonight

nnoremap <leader>s :split
nnoremap <leader>e :call ToggleNetrw()<CR>
nnoremap <leader>E :Explore %:p:h<CR>

"TERMINAL KEYMAPS 
nnoremap <leader>tt :tab terminal<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tb :tabpreviou<CR>
nnoremap <leader>b :ChangeBuf<CR>
nnoremap <leader>x :so%<CR>

"WINDOW KEY REMAPS
nnoremap + <C-w>+
nnoremap - <C-w>-

command! ShowBuf :call ShowBuf()
command! ChangeBuf :call ChangeBuf()

augroup NETRW
  autocmd!
  autocmd VimEnter * if isdirectory(argv(0)) | let g:ExploreBufNo = bufnr(argv(0)) | endif
augroup END

let g:prevBufNo = -1
let g:ExploreBufNo = -1

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

function! ShowBuf()
  let bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  for i in range(len(bufs))
    let str = (i+1) . ". " . fnamemodify(bufs[i].name, ":t")
    echo str
  endfor
endfunction

function! ToggleNetrw()
  if &filetype ==# "netrw"
    if g:prevBufNo != -1 && buflisted(g:prevBufNo)
      let g:ExploreBufNo = bufnr("%")
      execute 'buffer ' . g:prevBufNo
    endif
  else
    let g:prevBufNo = bufnr(expand("%"))
    if g:ExploreBufNo == -1 || !bufexists(g:ExploreBufNo)
      execute 'Explore'
    elseif bufexists(g:ExploreBufNo)
      execute 'buffer ' . g:ExploreBufNo
    endif
  endif
endfunction
