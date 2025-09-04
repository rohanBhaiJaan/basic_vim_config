let g:prevBufNo = -1
let g:ExploreBufNo = -1

let s:bufs = []
let s:index = 0

hi MyError ctermfg=215 ctermbg=196

function utils#functions#Utils() abort
  let self = {}

  function! self.defaultPopup(title, value) dict
    return popup_create(a:value, #{
          \title: a:title,
          \minwidth: 20,
          \minheight: 15,
          \maxwidth: 60,
          \close: 'click',
          \padding: [ 1, 3, 1, 3 ],
          \})

  endfunction

  function! self.GetCharTimeLimit(time_limit) dict
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
  
  return self
endfunction

let s:utils = utils#functions#Utils()

function! utils#functions#Buffer() abort
  let self = {}

  function! self.change()
    let s:bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
    echo "Enter the index of Buffer: "
    let l:rawIndex = s:utils.GetCharTimeLimit(2000)
    let s:index = str2nr(l:rawIndex)
    if l:rawIndex == ""
      call self.chooseUI()
      return 
    endif
    if s:index > 0 && s:index <= len(s:bufs) 
      execute 'buffer ' . s:bufs[s:index - 1].bufnr 
    else
      echoerr "invalid index"
    endif
  endfunction

  function! self.chooseUI()
    let s:bufs = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
    let value = []
    for i in range(len(s:bufs))
      call add(value, (i+1) . ". " . s:bufs[i].name)
    endfor
    let popup_id = s:utils.defaultPopup("buffer change", value)
    call popup_setoptions(popup_id, #{
          \filter: { id, key -> self.close(id, key) }
          \})
  endfunction

  function! self.close(id, key)
    let s:index = str2nr((a:key))
    call popup_close(a:id, 1)
    if s:index > 0 && s:index <= len(s:bufs)
      execute 'buffer ' . s:bufs[s:index - 1].bufnr
      return 1
    endif
    echoerr "invalid index"
    return 0
  endfunction

  return self
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

function utils#functions#Timer() abort
  let self = { "timer_id": [] }

  function self.popup(tid) dict
    let win_id = s:utils.defaultPopup("timer", "TIMER RAN OUT")
    call setwinvar(win_id, "&wincolor", 'MyError')
  endfunction

  function self.start(min) dict
    let time = float2nr(a:min*60)*1000
    let ringing_time =  strftime("%H:%M", localtime() + (time/1000))
    let id = timer_start(time, { tid -> self.popup(tid) })
    call add(self["timer_id"], {"id":  id, "end_time": ringing_time })
  endfunction

  function self.show() dict
    let win_id = s:utils.defaultPopup("Timer:[show]", "")
    let buf_id = winbufnr(win_id)

    for no in range(len(self["timer_id"]))
      let text = self["timer_id"][no]["id"] .. "  |  " .. self["timer_id"][no]["end_time"]
      call setbufline(buf_id, no+1, text )
    endfor
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
