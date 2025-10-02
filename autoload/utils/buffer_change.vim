let s:utils = utils#functions#Utils()

function! s:close(id, result, self)
  execute 'buffer ' . a:self["buffers"][a:result-1].bufnr
endfunction

function! s:choose_buffer(id, key, self)
  let index = str2nr((a:key))
  if index > 0 && index <= len(a:self["buffers"])
    call popup_close(a:id, index)
  else
    call popup_filter_menu(a:id, a:key)
  endif
  return 1
endfunction

function! s:delete_buffer(id, result, self) abort
  execute 'bdelete ' . a:self["buffers"][a:result-1].bufnr
  call remove(a:self["buffers"], a:result-1)
endfunction

function! utils#buffer_change#Buffer() abort
  let self = { "limit" : 5, "buffers": []}

  function! self.change() dict
    let self["buffers"] = filter(getbufinfo(), { _, val -> val.listed && !empty(val.name) && filereadable(val.name) })->mapnew({_, val -> { "name": val["name"], "bufnr": val["bufnr"] }})
    echo "Enter the index of Buffer: "
    let rawIndex = s:utils.GetCharTimeLimit(2000)
    if rawIndex == ""
      call self.chooseUI()
      return 
    endif
    let index = str2nr(rawIndex)
    try
      execute 'buffer ' . self["buffers"][index - 1].bufnr 
    catch
      echoerr "invalid index"
    endtry
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

  function! self.deleteBuffer() dict
    let value = mapnew(self["buffers"], {idx, val ->  idx+1 . '. '. val["name"]})
    let popup_id = s:utils.defaultPopup("buffer change", value)
    call popup_setoptions(popup_id, #{
          \cursorline: v:true,
          \filter: "popup_filter_menu",
          \callback: { id, result -> s:delete_buffer(id, result, self) }
          \})
  endfunction

  return self
endfunction

