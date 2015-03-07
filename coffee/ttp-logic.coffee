boardRows = 'abc'.split ''
boardCols = [1..3]

board = (R, C) -> [].concat (C.map (c) -> R.map (r) -> r + c)...

brd = board boardRows, boardCols

$ ->
  turn = 0; $('#turn').text 'O'
  $ '#mainBoard'
    .append brd.map((cell) -> "<div class='cell' data-coords='#{cell}'><div>#{cell}</div></div>").join ''
    .on 'click', '.cell', ->
      if !$(@).hasClass('circle') && !$(@).hasClass('cross')
        $(@).addClass ['circle', 'cross'][turn]
        turn = 1 - turn; $('#turn').text 'OX'[turn]
      return
  return
