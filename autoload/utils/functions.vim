let g:prevBufNo = -1
let g:ExploreBufNo = -1

let s:bufs = []
let s:index = 0

function! utils#functions#ChangeBuf()
  let s:bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  echo "Enter the index of Buffer: "
  let s:index = str2nr(nr2char(getchar()))
  if s:index > 0 && s:index <= len(s:bufs)
    execute 'buffer ' . s:bufs[s:index - 1].bufnr
  else
    echoerr 'Invalid Index'
  endif
endfunction

function! s:close(id, key)
  let s:index = str2nr((a:key))
  call popup_close(a:id, 1)
  if s:index > 0 && s:index <= len(s:bufs)
    execute 'buffer ' . s:bufs[s:index - 1].bufnr
    return 1
  else
    call popup_close(a:id, 1)
    return 0
  endif
  return 0
endfunction

function! utils#functions#ShowChangeBuf()
  let s:bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  let value = []
  for i in range(len(s:bufs))
    call add(value, (i+1) . ". " . s:bufs[i].name)
  endfor
  call popup_create(value, #{
        \minwidth: 20,
        \minheight: 15,
        \maxwidth: 60,
        \close: 'click',
        \filter: 's:close',
        \padding: [ 1, 3, 1, 3 ],
        \})
endfunction

function! utils#functions#ToggleNetrw()
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

function! utils#functions#FindCppFunction()
  let l:cppFunction = expand("<cword>")
  execute 'vimgrep /' . l:cppFunction . '/ **/*.cpp'
endfunction

function! utils#functions#GetVisualModeContent() range
  echo getline(a:firstline, a:lastline)
endfunction
