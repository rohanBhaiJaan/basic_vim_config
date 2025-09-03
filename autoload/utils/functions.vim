let g:prevBufNo = -1
let g:ExploreBufNo = -1

let s:bufs = []
let s:index = 0

hi MyError ctermfg=215 ctermbg=196

function! s:GetCharTimeLimit(time_limit)
  let start_time = reltime()
  while 1
    let ch = getchar(0)
    if ch
      return type(ch) == 0 ? nr2char(ch) : ch
    endif
    let time_spend = (reltime(start_time)->reltimefloat()) * 1000
    if time_spend > a:time_limit
      return ''
    endif
  endwhile
endfunction

function! s:close(id, key)
  let s:index = str2nr((a:key))
  call popup_close(a:id, 1)
  if s:index > 0 && s:index <= len(s:bufs)
    execute 'buffer ' . s:bufs[s:index - 1].bufnr
    return 1
  else
    echoerr "invalid index"
    return 0
  endif
endfunction

function! utils#functions#ChangeBuf()
  let s:bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
  echo "Enter the index of Buffer: "
  let l:rawIndex = s:GetCharTimeLimit(2000)
  let s:index = str2nr(l:rawIndex)
  if l:rawIndex == ""
    call utils#functions#ShowChangeBuf()
    return 
  endif
  if s:index > 0 && s:index <= len(s:bufs) 
    execute 'buffer ' . s:bufs[s:index - 1].bufnr 
  else
    echoerr "invalid index"
  endif
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

function utils#functions#Timer(min) abort
  let self = { "min": a:min, "timer_id": -1 }

  function self.popup(tid) dict
    let win_id = popup_create("TIMER RAN OUT", #{
          \title: "timer",
          \border: [],
          \padding: [1, 2, 1, 2 ],
          \close: "click",
          \})
    call setwinvar(win_id, "&wincolor", 'MyError')
  endfunction

  function self.start() dict
    let self["timer_id"] = timer_start(float2nr(self["min"]*60)*1000, { tid -> self.popup(tid) })
  endfunction

  return self
endfunction

function! utils#functions#FindCppFunction()
  let l:cppFunction = expand("<cword>")
  execute 'vimgrep /' . l:cppFunction . '/ **/*.cpp'
endfunction

function! utils#functions#GetVisualModeContent() range
  echo getline(a:firstline, a:lastline)
endfunction
