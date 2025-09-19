



" convert to min heap
" modify heap data check


function utils#dsa#Heap()
  " return {"id":  timer_id
  " end_time: ringing_time
  " label: a:text }
  let self = { "arr": [], }

  function self.add(value) dict
    call add(self.arr, a:value)
    call self.bubble_up(len(self.arr)-1)
  endfunction

  function self.pop(index = 0)
    let value = self.arr[a:index]
    call self.swap(a:index, len(self.arr)-1)
    call remove(self.arr, len(self.arr)-1)
    call self.bubble_down(a:index)
    return value
  endfunction

  function self.bubble_up(index)
    let index = a:index
    while index > 0
      let parent = self.getParent(index)
      if self.arr[parent].end_time > self.arr[index].end_time
        call self.swap(index, parent)
        let index = parent
      else
        break
      endif
    endwhile
  endfunction

  function self.look()
    if len(self.arr) == 0
      return ""
    endif
    return self.arr[0]
  endfunction

  function self.bubble_down(index)
    let index = a:index
    let length = len(self.arr)
    while index < length
      let left = self.getLeft(index)
      let right = self.getRight(index)
      if left < length && self.arr[index].end_time > self.arr[left].end_time
        call self.swap(index, left)
        let index = left
      elseif right < length && self.arr[index].end_time > self.arr[right].end_time
        call self.swap(index, right)
        let index = right
      else
        break
      endif
    endwhile
  endfunction

  function self.getParent(index)
    return (a:index-1)/2
  endfunction

  function self.getLeft(index)
    return (a:index*2)+1
  endfunction

  function self.getRight(index)
    return (a:index*2)+2
  endfunction

  function self.swap(index1,index2)
    let temp = self.arr[a:index1]
    let self.arr[a:index1] = self.arr[a:index2]
    let self.arr[a:index2] = temp
  endfunction

  return self
endfunction

" let heap = Heap()
" call heap.add({"end_time": 34})
" call heap.add({"end_time": 3})
" " echo heap.pop()
" call heap.add({"end_time": 31})
" call heap.add({"end_time": 43})
" call heap.add({"end_time": 27})
" " echo heap.pop()
" call heap.add({"end_time": 37})

" echo heap.arr
