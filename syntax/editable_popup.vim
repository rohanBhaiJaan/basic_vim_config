



if exists("g:my_editable_popup")
  finish
endif

let g:my_editable_popup = 1

highlight default MyEpopup ctermfg=white ctermbg=52 guifg=white guibg=red

syntax match MyEpopup /.$/
