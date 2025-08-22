" ~/.vim/compiler/clangpp.vim
if exists("current_compiler")
  finish
endif
let current_compiler = "clangpp"

" Build command: clang++ main.cpp lib/*.cpp -o a.out
setlocal makeprg=clang++\ main.cpp\ lib/*.cpp\ -o\ a.out

" Errorformat for clang++
setlocal errorformat=%f:%l:%c:\ %trror:\ %m
setlocal errorformat+=%f:%l:%c:\ %tarning:\ %m
setlocal errorformat+=%f:%l:%c:\ %m

