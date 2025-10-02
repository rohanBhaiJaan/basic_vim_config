let g:prevBufNo = -1
let g:ExploreBufNo = -1

let buffer = utils#buffer_change#Buffer()
let timer = utils#timer#App()

let s:timerstart = timer.start

call timer.startup()
set statusline+=%=\ %{timer.first()}

call timer_start(1000*60*2, { -> popup_dialog(["You want to start a 20 min timer[y/n]"], #{
      \ filter: "popup_filter_yesno",
      \ callback: {id, result -> result ? g:timer.start(20) : result}
      \})})
