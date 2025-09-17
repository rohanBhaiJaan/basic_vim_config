command! Tags :call system("ctags -R .")

nnoremap <buffer> <leader>fl :call utils#functions#FindCppFunction()<CR>
nnoremap <buffer> <leader>fo :copen<CR>
nnoremap <buffer> <leader>fc :cclose<CR>
nnoremap <buffer> <leader>fn :cnext<CR>
nnoremap <buffer> <leader>fp :cprevious<CR>
