
let s:utils = utils#functions#Utils()

function utils#timer#App() abort
  let self = { "timer_id": [], "buffer": " " }

  function self.getTimerObj(time, text) dict
    let ringing_time =  strftime("%H:%M", localtime() + (a:time))
    let timer_id = timer_start(a:time*1000, { tid -> self.end_popup(tid) })
    return {"id":  timer_id, "end_time": ringing_time, "label": a:text }
  endfunction

  function self.startup()
    let filecontent = readfile(expand("$HOME") .. "/.config/timer/timer.txt")

    for line in filecontent
      let splitContent = split(line, '|')
      let cur_time = localtime()
      if (str2nr(splitContent[1]) > cur_time )
        let time = str2nr(splitContent[1]) - cur_time
        let timer_obj = self.getTimerObj(time, splitContent[0])
        call add(self["timer_id"], timer_obj)
      endif
    endfor

  endfunction

  function self.end_popup(tid) dict
    let win_id = s:utils.defaultPopup("timer", "TIMER RAN OUT")
    call setwinvar(win_id, "&wincolor", 'MyError')
    call self.delete(a:tid)
  endfunction

  function self.save_timer(pid, min) dict
    let timer_obj = self.getTimerObj(a:min*60, self["buffer"])
    call add(self["timer_id"], timer_obj)
    let text = self["buffer"] .. ' | ' .. (localtime() + (a:min*60))
    call writefile([ text ], expand("$HOME") .. '/.config/timer/timer.txt', 'a')
  endfunction

  function self.start(min) dict
    let self["buffer"] = " "
    let label = s:utils.defaultPopup("Timer: Perpose of Timer?", self["buffer"])
    call popup_setoptions(label, #{
          \filter: {id, key -> s:utils.editablePopup(id, key, self, "buffer")},
          \callback: {id, -> self.save_timer(id, a:min)},
          \border: [],
          \filetype: "editable_popup",
          \})
    call win_execute(label, "setlocal syntax=editable_popup")
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

  function self.delete(timer_id)
    call timer_stop(a:timer_id)
    for index in range(len(self["timer_id"]))
      if self["timer_id"][index]["id"] != a:timer_id | continue | endif
      call remove(self["timer_id"], index)
      break
    endfor
  endfunction

  return self
endfunction
