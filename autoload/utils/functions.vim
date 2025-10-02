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
