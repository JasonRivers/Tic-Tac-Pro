boardRows = 'abc'.split ''
boardCols = [1..3]

board = (R, C) -> [].concat (C.map (c) -> R.map (r) -> r + c)...

brd = board boardRows, boardCols

winningTriples = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

$ ->
  turn = 0; $('#turn').text 'O'
  $ '#mainBoard'
    .append brd.map((cell) -> "<div class='cell' data-coords='#{cell}'><div>#{cell}</div></div>").join ''
    .on 'click', '.cell', ->
      if !$(@).hasClass('circle') && !$(@).hasClass('cross')
        $(@).addClass myClass = ['circle', 'cross'][turn]
        $s = $(@).parent().children() # siblings, including self
        for t in winningTriples
          if $s.eq(t[0]).hasClass(myClass) && $s.eq(t[1]).hasClass(myClass) && $s.eq(t[2]).hasClass(myClass)
            alert 'OX'[turn] + ' wins'
            break
        turn = 1 - turn; $('#turn').text 'OX'[turn]
      return
  return
