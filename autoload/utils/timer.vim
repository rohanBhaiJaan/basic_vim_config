



let s:utils = utils#functions#Utils()
let s:heap = utils#dsa#Heap()

function utils#timer#App() abort
  let self = { "timer_id": s:heap.arr, "buffer": " " }

  function self.getTimerObj(time, text) dict
    let ringing_time =  strftime("%H:%M", localtime() + (a:time))
    let timer_id = timer_start(a:time*1000, { tid -> self.end_popup(tid) })
    return {"id":  timer_id, "end_time": ringing_time, "label": a:text }
  endfunction

  function self.getPrevTimers() dict
    let filecontent = readfile(expand("$HOME") .. "/.config/timer/timer.txt")
    let timer_arr = []
    for line in filecontent
      let splitContent = split(line, '|')
      let cur_time = localtime() | let time = str2nr(splitContent[1]) - cur_time
      if (str2nr(splitContent[1]) > cur_time )
        call add(timer_arr, [time, splitContent[0]])
      endif
    endfor
    return timer_arr
  endfunction

  function self.start_new_timer(value) dict
    let timer_obj = self.getTimerObj(a:value[0], a:value[1])
    call s:heap.add(timer_obj)
    let text = self["buffer"] .. ' | ' .. (localtime() + (a:min*60))
    call writefile([ text ], expand("$HOME") .. '/.config/timer/timer.txt', 'a')
  endfunction

  function self.startup()
    let prev_timer = self.getPrevTimers()
    for timer in prev_timer
      let timer_obj = self.getTimerObj(timer[0], timer[1])
      call s:heap.add(timer_obj)
    endfor
  endfunction

  function self.end_popup(tid) dict
    let win_id = s:utils.defaultPopup("timer", "TIMER RAN OUT")
    call setwinvar(win_id, "&wincolor", 'MyError')
    call self.delete(a:tid)
  endfunction

  function self.first()
    let value = s:heap.look()
    return type(value) == v:t_string ? value : value.end_time
  endfunction

  function self.save_timer(pid, min) dict
    if trim(self.buffer)->len() == 0
      return 
    endif
    let timer_obj = self.getTimerObj(a:min*60, self["buffer"])
    call s:heap.add(timer_obj)
    let text = self["buffer"] .. ' | ' .. (localtime() + (a:min*60))
    call writefile([ text ], expand("$HOME") .. '/.config/timer/timer.txt', 'a')
  endfunction

  function self.start(min) dict
    let self["buffer"] = " "
    let label = s:utils.defaultPopup("Timer: Perpose of Timer?", self["buffer"])
    call popup_setoptions(label, #{
          \filter: {id, key -> s:utils.editablePopup(id, key, self, "buffer")},
          \callback: {id, -> self.save_timer(id, a:min) },
          \border: [],
          \filetype: "editable_popup",
          \})
    call win_execute(label, "setlocal filetype=editable_popup")
    " call win_execute(label, "let syntax=editable_popup")
  endfunction

  function self.show() dict
    let win_id = s:utils.defaultPopup("Timer:[show]", "")
    let buf_id = winbufnr(win_id)

    for no in range(len(self["timer_id"]))
      let text = self["timer_id"][no]["id"] .. "  |  " .. self["timer_id"][no]["end_time"]  .. "  |  " .. self["timer_id"][no]["label"]
      call setbufline(buf_id, no+1, text )
    endfor
  endfunction

  function self.pause(timer_id)
    call timer_pause(a:timer_id)
  endfunction

  function self.delete(timer_id = 0)
    if a:timer_id != 0
      echo "sorry not implemented yet"
      return 
    endif
    let timer = s:heap.pop()
    call timer_stop(timer["id"])
  endfunction

  return self
endfunction
