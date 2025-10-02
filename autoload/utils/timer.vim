

let s:utils = utils#functions#Utils()
let s:heap = utils#dsa#Heap()

function utils#timer#App() abort
  let self = { "timer_id": s:heap, "paused_timers": utils#dsa#Heap(), "buffer": " " }

  function self.getTimerObj(time, text) dict
    let timer_id = timer_start(a:time*1000, { tid -> self.end_popup(tid) })
    return {"id":  timer_id, "end_time": localtime() + (a:time), "label": a:text }
  endfunction

  function self.getPrevTimers() dict
    let filecontent = readfile(expand("$HOME") .. "/.config/timer/timer.txt")
    let timer_arr = []
    for line in filecontent
      if line == "" | continue | endif
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
    call self.writefile()
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
    call s:heap.pop()
  endfunction

  function self.first()
    let value = s:heap.look()
    return type(value) == v:t_string ? value : strftime("%H:%M:%S", value.end_time)
  endfunction

  function self.save_timer(pid, min) dict
    if trim(self.buffer)->len() == 0
      return 
    endif
    let timer_obj = self.getTimerObj(a:min*60, self["buffer"])
    call s:heap.add(timer_obj)
    call self.writefile()
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
  endfunction

  function self.show(array = "timer_id") dict
    if empty(self[a:array].arr) | return | endif
    let win_id = s:utils.defaultPopup("Timer:[show]", "")
    let buf_id = winbufnr(win_id)

    let index = 0
    for item in self[a:array].arr
      let text = item["id"] .. "  |  " .. strftime("%H:%M", item["end_time"])  .. "  |  " .. item["label"]
      let index += 1
      call setbufline(buf_id, index, text )
    endfor

    return win_id
  endfunction

  function self.writefile()
    call writefile(
          \ mapnew(self["timer_id"].arr, {_, var -> var.label .. ' | ' .. var.end_time}),
          \ expand("$HOME/.config/timer/timer.txt"))
  endfunction

  function self.delete_timer(id, result)
    let timer = s:heap.pop(a:result-1)
    call timer_stop(timer["id"])
    call self.writefile()
    return timer
  endfunction

  function self.pause_timer(id, result) dict
    let timer = self.delete_timer(a:id, a:result)
    let timer["end_time"] = timer["end_time"] - localtime()
    echo "remaining: " .timer["end_time"]
    call self["paused_timers"].add(timer)
  endfunction

  function self.resume_timer(id, result) dict
    let paused_timer = self["paused_timers"].pop()
    let timer = self.getTimerObj(paused_timer["end_time"], paused_timer["label"])
    call self["timer_id"].add(timer)
  endfunction

  function self.delete()
    let win_id = self.show()
    call popup_setoptions(win_id, #{
          \title: "Timer [Delete]",
          \cursorline: 1,
          \filter: "popup_filter_menu",
          \callback: { id, result -> self.delete_timer(id, result) }
          \})
  endfunction

  function self.pause()
    let win_id = self.show()
    call popup_setoptions(win_id, #{
          \title: "Timer [Pause]",
          \cursorline: 1,
          \filter: "popup_filter_menu",
          \callback: { id, result -> self.pause_timer(id, result) }
          \})
  endfunction

  function self.resume() dict
    let win_id = self.show("paused_timers")
    call popup_setoptions(win_id, #{
          \title: "Timer [Paused Timers]",
          \cursorline: 1,
          \filter: "popup_filter_menu",
          \callback: { id, result -> self.resume_timer(id, result) }
          \})
  endfunction

  return self
endfunction
