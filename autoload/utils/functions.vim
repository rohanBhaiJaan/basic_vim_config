let s:buffer = ""
let s:bufs = []
let s:index = 0

hi MyError ctermfg=215 ctermbg=196 guifg=white guibg=red

function utils#functions#Utils() abort
  let self = { "buffer": "" }

  function! self.defaultPopup(title, value) dict
    return popup_create(a:value, #{
          \title: a:title,
          \minwidth: 20,
          \minheight: 15,
          \maxwidth: 60,
          \close: 'click',
          \mapping: 0,
          \padding: [ 1, 3, 1, 3 ],
          \})

  endfunction

  function self.removeLast(item) dict
      return a:item[:-2]
  endfunction

  function! self.editablePopup(id, key, dict, dkey, ) abort
    let start_time = reltime()
    if a:key ==# "\<BS>" || char2nr(a:key) == 8
      let self.buffer = self.removeLast(self.buffer)
      call popup_settext((a:id), self.buffer . ' ')
    elseif char2nr(a:key) == 23
      let self.buffer = self.removeLast(split(self.buffer, ' '))->join(" ")
      call popup_settext((a:id), self.buffer . ' ')
    elseif len(a:key) == 3
      return 1
    elseif char2nr(a:key) == 13 && len(self.buffer) > 1
      let self["buffer"] = ""
      call popup_close(a:id)
      return 1
    elseif char2nr(a:key) > 31
      if len(self.buffer) < 15
        let self.buffer = self.buffer . a:key
        call popup_settext((a:id), self.buffer . ' ')
      endif
    endif
    let a:dict[a:dkey] = self["buffer"]
    return 1
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

function! s:close(id, result, self)
  execute 'buffer ' . a:self["buffers"][a:result-1].bufnr
endfunction

function! s:choose_buffer(id, key, self)
  let s:index = str2nr((a:key))
  if s:index > 0 && s:index <= len(a:self["buffers"])
    call popup_close(a:id, s:index)
  else
    call popup_filter_menu(a:id, a:key)
  endif
  return 1
endfunction

function! utils#functions#Buffer() abort
  let self = { "limit" : 5, "buffers": []}

  function! self.change() dict
    let self["buffers"] = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })
    echo "Enter the index of Buffer: "
    let l:rawIndex = s:utils.GetCharTimeLimit(2000)
    let s:index = str2nr(l:rawIndex)
    if l:rawIndex == ""
      call self.chooseUI()
      return 
    endif
    if s:index > 0 && s:index <= len(self["buffers"]) 
      execute 'buffer ' . self["buffers"][s:index - 1].bufnr 
    else
      echoerr "invalid index"
    endif
  endfunction

  function! self.chooseUI() dict
    let value = mapnew(self["buffers"], {idx, val ->  idx+1 . '. '. val["name"]})
    let popup_id = s:utils.defaultPopup("buffer change", value)
    call popup_setoptions(popup_id, #{
          \cursorline: v:true,
          \filter: { id, key -> s:choose_buffer(id, key, self) },
          \callback: { id, result -> s:close(id, result, self) }
          \})
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

function utils#functions#Reason() abort
  " day: { time, spend } retrive from session_vim.txt [ day | time | spend ]
  let self = { "session": [], "startup": -1, "spendtime": -1, "reason": ""  }

  " callback function to save reason
  function self.saveReason(id) dict
    let self["reason"] = s:buffer
    echo self
  endfunction
  "
  " startup && reason
  function self.start_up() dict
    let s:buffer = ""
    let self["startup"] = reltime()
    let prompt = s:utils.defaultPopup("Reason", "Why opened the vim?" )
    call popup_setoptions(prompt, #{
          \filter: { id, key -> s:utils.editablePopup(id, key) },
          \callback: { id -> self.saveReason(id) }
          \})
  endfunction

  " spend time
  function self.exit() dict
    let self["spendtime"] = reltime(self["startup"])->reltimefloat()->float2nr()
    call self.save_to_file()
    echo self
    execute 'abort'
  endfunction

  " save them in a file
  function self.save_to_file() dict
    let format = strftime("%Y %b %d [%H:%M]", self["startup"])
    call writefile([ format ], "session_vim.txt", "a")
  endfunction

  " retrive them
  " totaltime
  " noOfSessions { no: number, duration: reltime(start)->reltimefloat() }

  return self 
endfunction

function! utils#functions#FindCppFunction()
  let l:cppFunction = expand("<cword>")
  execute 'vimgrep /' . l:cppFunction . '/ **/*.cpp'
endfunction

function! utils#functions#GetVisualModeContent() range
  echo getline(a:firstline, a:lastline)
endfunction
