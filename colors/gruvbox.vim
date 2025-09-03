" ~/.vim/colors/mygruv.vim
if exists("syntax_on")
  syntax reset
endif

set background=dark
highlight clear
let g:colors_name = "mygruv"

" Base
hi Normal       guifg=#ebdbb2 guibg=#282828 ctermfg=223 ctermbg=235
hi CursorLine   guibg=#3c3836 ctermbg=237
hi CursorLineNr guifg=#fabd2f gui=bold ctermfg=214
hi LineNr       guifg=#7c6f64 ctermfg=243

" Comments & text
hi Comment      guifg=#928374 gui=italic ctermfg=244
hi String       guifg=#b8bb26 ctermfg=142
hi Constant     guifg=#d3869b ctermfg=175
hi Identifier   guifg=#83a598 ctermfg=109
hi Function     guifg=#fabd2f ctermfg=214
hi Keyword      guifg=#fe8019 ctermfg=208
hi Type         guifg=#8ec07c ctermfg=108
hi Number       guifg=#d3869b ctermfg=175

" UI bits
hi StatusLine   guifg=#ebdbb2 guibg=#3c3836 ctermfg=223 ctermbg=237
hi StatusLineNC guifg=#a89984 guibg=#3c3836 ctermfg=246 ctermbg=237
hi Visual       guibg=#504945 ctermbg=239
hi Search       guifg=#282828 guibg=#fabd2f ctermfg=235 ctermbg=214
hi IncSearch    guifg=#282828 guibg=#fe8019 ctermfg=235 ctermbg=208
hi Pmenu        guifg=#ebdbb2 guibg=#3c3836 ctermfg=223 ctermbg=237
hi PmenuSel     guifg=#282828 guibg=#83a598 ctermfg=235 ctermbg=109

" Diagnostics (if using ALE/LSP)
hi Error        guifg=#fb4934 ctermfg=167
hi WarningMsg   guifg=#fe8019 ctermfg=208
hi Todo         guifg=#fabd2f guibg=#282828 gui=bold ctermfg=214 ctermbg=235
