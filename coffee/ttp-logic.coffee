boardRows = 'abc'.split ''
boardCols = [1..3]
mode      = "classic"
board     = "main"

boardcells = (R, C) -> [].concat (C.map (c) -> R.map (r) -> r + c)...

brd = boardcells boardRows, boardCols

winningTriples = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

playsound = (sound) ->
  audio = document.getElementById 'sound'
  audio.setAttribute 'src', 'assets/sounds/'+sound
  audio.volume='0.3'
  audio.play()

$ ->
  turn = 0
  $('#turnIcon')
    .removeClass 'circle'
    .removeClass 'cross'
    .addClass myClas = ['circle',' cross'][turn]
    .html '<div></div>'
    $('#turnIcon.circle div')
      .css 'border-width', $('#turnIcon.circle').width()/100*20
  $ '.gameBoard'
    .append brd.map((cell) -> "<div class='cell free' data-coords='#{cell}'><div></div></div>").join ''
    .on 'click', '.cell.free',(event) ->
      if board == "main" && mode == "pro"
        board = $(@).attr 'data-coords'
        $('#boardTitle span').html board
      else
        playsound 'click.ogg'
        if !$(@).hasClass('circle') && !$(@).hasClass('cross')
          $(@)
            .addClass myClass = ['circle', 'cross'][turn]
            .removeClass 'free'

          $s = $(@).parent().children() # siblings, including self
          $('.circle div').css('border-width', $('.cell').height()/100*20;)
          for t in winningTriples
            if $s.eq(t[0]).hasClass(myClass) && $s.eq(t[1]).hasClass(myClass) && $s.eq(t[2]).hasClass(myClass)
              playsound('badumtsh.ogg')
              $('.free').removeClass 'free'
              if mode == "classic" || (mode == "pro" && board =="main")
                $ 'body'
                  .append('<div id="dialog">'+['Circle','Cross'][turn]+' wins!</div>')
                $ '#dialog'
                  .dialog
                    'draggable' : false
                    'min-height' : 50
                    'resizable' : false
                    'modal'     : true
                    'buttons'   :
                      'New Game'  : ->
                        $('.cell')
                          .removeClass 'circle'
                          .removeClass 'cross'
                          .addClass 'free'
                        $(@).dialog 'destroy'
                        $('#dialog').remove()
              break
          turn = 1 - turn; 
          $('#turnIcon')
            .removeClass 'circle'
            .removeClass 'cross'
            .addClass myClas = ['circle',' cross'][turn]
            .html '<div></div>'
            $('#turnIcon.circle div')
              .css 'border-width', $('#turnIcon.circle').width()/100*20
          if mode == "pro"
            board = "main"
            $('#boardTitle span').html board
      return

  $ window
    .resize ->
      boardSize = $(window).height()/100*80
      $('.gameBoard').css
        'height':boardSize+'px'
        'width':boardSize+'px'
      $('.circle div')
        .css 'border-width', $('.cell').height()/100*20
      $('#turnIcon.circle div')
        .css 'border-width', $('#turnIcon.circle').width()/100*20

    .load ->
      boardSize = $(window).height()/100*80
      $('.gameBoard').css
        'height':boardSize+'px'
        'width':boardSize+'px'
