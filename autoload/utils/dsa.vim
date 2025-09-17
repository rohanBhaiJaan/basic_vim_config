


function Heap()
  let self = { "arr": [], }

  function self.add(value) dict
    call add(self.arr, a:value)
    call self.bubble_up(len(self.arr)-1)
  endfunction

  function self.pop()
    let value = self.arr[0]
    call self.swap(0, len(self.arr)-1)
    let self.arr = self.arr[:-2]
    call self.bubble_down(0)
    return value
  endfunction

  function self.bubble_up(index)
    if a:index == 0 | return | endif
    let index = a:index
    while index > 0
      let parent = self.getParent(index)
      if self.arr[parent] < self.arr[index]
        call self.swap(index, parent)
        let index = parent
      else
        break
      endif
    endwhile
  endfunction

  function self.bubble_down(index)
    let index = a:index
    let length = len(self.arr)
    while index < length
      let left = self.getLeft(index)
      let right = self.getRight(index)
      if left < length && self.arr[index] < self.arr[left]
        call self.swap(index, left)
        let index = left
      elseif right < length && self.arr[index] < self.arr[right]
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

let heap = Heap()
call heap.add(34)
call heap.add(3)
echo heap.pop()
call heap.add(31)
call heap.add(43)
call heap.add(27)
echo heap.pop()
call heap.add(37)

echo heap.arr
