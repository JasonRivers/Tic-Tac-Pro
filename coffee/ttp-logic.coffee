@Game ?= {}

boardRows = 'abc'.split ''
boardCols = [1..3]
board    =
  'mode'    : 'classic'
  'board'   : 'main'
  'score'   :
    'circle'  : 0
    'cross'   : 0
  'cells' : 
    'main'  :
      'free'    : []
      'circle'  : []
      'cross'   : []
settings  =
  'volume'  :
    'sounds'  : 0.3
    'music'   : 0.3


boardcells = (R, C) -> [].concat (C.map (c) -> R.map (r) -> r + c)...

brd = boardcells boardRows, boardCols

winningTriples = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

playsound = (sound) ->
  if settings.volume.sounds != 0
    audio = document.getElementById 'sound'
    audio.volume=settings.volume.sounds
    audio.setAttribute 'src', 'assets/sounds/'+sound
    audio.play()

if process? then do ->
  gui = require 'nw.gui'
  fs  = require 'fs'

  Game.nwjs = true
  Game.process = process
  Game.status = board
  Game.settings = settings
  gui.Screen.Init()
  nwg = gui.Window.get()
  Game.status.cells.main.free = brd ##All cells are available to start with
  
  $ ->

    $(document)
      .on 'keydown', '*', 'f12', -> nwg.showDevTools(); false
      .on 'keydown', '*', 'ctrl+shift+f12', -> foo.bar
      .on 'keydown', '*', 'alt+w', -> process.nextTick -> nwg.close true

    turn = 0
    $('#gameMode span').html Game.status.mode
    $('#boardTitle span').html Game.status.board
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
        if Game.status.board == "main" && Game.status.mode == "pro"
          Game.status.board = $(@).attr 'data-coords'
          $('#boardTitle span').html Game.status.board
        else
          if !$(@).hasClass('circle') && !$(@).hasClass('cross')
            $(@)
              .addClass myClass = ['circle', 'cross'][turn]
              .removeClass 'free'
              playsound 'click.ogg'
              Game.status.cells.main.circle = [] ## Reset
              Game.status.cells.main.square = [] ## Reset
              $('.cell.circle').each ->
                Game.status.cells.main.circle.push $(this).attr 'data-coords' 
              $('.cell.cross').each ->
                Game.status.cells.main.cross.push $(this).attr 'data-coords' 

            $s = $(@).parent().children() # siblings, including self
            $('.circle div').css('border-width', $('.cell').height()/100*20;)
            for t in winningTriples
              if $s.eq(t[0]).hasClass(myClass) && $s.eq(t[1]).hasClass(myClass) && $s.eq(t[2]).hasClass(myClass)
                playsound('badumtsh.ogg')
                if Game.status.mode == "classic" || (Game.status.mode == "pro" && Game.status.board =="main")
                  if turn
                    Game.status.score.cross++
                  else
                    Game.status.score.circle++

                  $ 'body'
                    .append('<div id="dialog" class="dialogbox">'+['Circle','Cross'][turn]+' wins!</div>')
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
                          $('.dialogbox').remove()
                break
            Game.status.cells.main.free = [] ## Reset
            $('.free').each ->
              Game.status.cells.main.free.push $(this).attr 'data-coords' 
            if Game.status.cells.main.free.length == 0
              $ 'body'
                .append('<div id="dialog">It\'s a Draw!</div>')
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

            turn = 1 - turn; 
            $('#turnIcon')
              .removeClass 'circle'
              .removeClass 'cross'
              .addClass myClas = ['circle',' cross'][turn]
              .html '<div></div>'
              $('#turnIcon.circle div')
                .css 'border-width', $('#turnIcon.circle').width()/100*20
            if Game.status.mode == "pro"
              Game.status.board = "main"
              $('#boardTitle span').html Game.status.board
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

  process.on 'uncaughtException', (e) ->
    window.lastError = e
    bugger = """
      #{e.stack}
    """

    document.write """
      <html>
        <head><title>Bugger!</title></head>
        <body>
          <h1>Bugger...</h1>
          <p>Well, it didn't like that, did it?</p>
          <textarea autofocus style="width:100%;height:70%" nowrap>#{bugger}</textarea>
        </body>
      </html>
    """
    false
