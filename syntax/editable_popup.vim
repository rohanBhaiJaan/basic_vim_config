
if exists("g:my_editable_popup")
  finish
endif

highlight default MyEpopup ctermfg=white ctermbg=52 guifg=white guibg=red
syntax match MyEpopup /.$/

