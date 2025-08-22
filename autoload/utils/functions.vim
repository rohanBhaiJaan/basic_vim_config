let g:prevBufNo = -1
let g:ExploreBufNo = -1

function! utils#functions#ChangeBuf()
  let bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  echo "Enter the index of Buffer: "
  let index = str2nr(nr2char(getchar()))
  if index > 0 && index <= len(bufs)
    execute 'buffer ' . bufs[index - 1].bufnr
  else
    echoerr 'Invalid Index'
  endif
endfunction

function! utils#functions#ShowBuf()
  let bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  for i in range(len(bufs))
    let str = (i+1) . ". " . fnamemodify(bufs[i].name, ":t")
    echo str
  endfor
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
