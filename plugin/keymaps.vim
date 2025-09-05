nnoremap <leader>ff :find 
xnoremap <silent> <leader>p :call GetVisualModeContent()<CR>

nnoremap <silent> <leader>e :call utils#functions#ToggleNetrw()<CR>
nnoremap <leader>E :Explore %:p:h<CR>
nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <silent> <leader>b :call buffer.change()<CR>
nnoremap <leader>ts :call timer.start()<CR>

nnoremap <leader>x :so%<CR>
nnoremap <leader>n :set nu! rnu!<CR>

"WINDOW KEY REMAPS
nnoremap + <C-w>+
nnoremap - <C-w>-
