let g:prevBufNo = -1
let g:ExploreBufNo = -1

let buffer = utils#functions#Buffer()
let timer = utils#timer#App()

call timer.startup()
breakadd func timer.startup

" let reason = utils#functions#Reason()
