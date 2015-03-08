// Generated by CoffeeScript 1.8.0
(function() {
  var board, boardCols, boardRows, brd, winningTriples;

  boardRows = 'abc'.split('');

  boardCols = [1, 2, 3];

  board = function(R, C) {
    var _ref;
    return (_ref = []).concat.apply(_ref, C.map(function(c) {
      return R.map(function(r) {
        return r + c;
      });
    }));
  };

  brd = board(boardRows, boardCols);

  winningTriples = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];

  $(function() {
    var myClas, turn;
    turn = 0;
    $('#turnIcon').removeClass('circle').removeClass('cross').addClass(myClas = ['circle', ' cross'][turn]).html('<div></div>');
    $('#turnIcon.circle div').css('border-width', $('#turnIcon.circle').width() / 100 * 20);
    $('.gameBoard').append(brd.map(function(cell) {
      return "<div class='cell free' data-coords='" + cell + "'><div></div></div>";
    }).join('')).on('click', '.cell.free', function() {
      var $s, myClass, t, _i, _len;
      if (!$(this).hasClass('circle') && !$(this).hasClass('cross')) {
        $(this).addClass(myClass = ['circle', 'cross'][turn]).removeClass('free');
        $s = $(this).parent().children();
        $('.circle div').css('border-width', $('.cell').height() / 100 * 20);
        for (_i = 0, _len = winningTriples.length; _i < _len; _i++) {
          t = winningTriples[_i];
          if ($s.eq(t[0]).hasClass(myClass) && $s.eq(t[1]).hasClass(myClass) && $s.eq(t[2]).hasClass(myClass)) {
            $('.free').removeClass('free');
            alert('OX'[turn] + ' wins');
            break;
          }
        }
        turn = 1 - turn;
        $('#turnIcon').text('OX'[turn]).removeClass('circle').removeClass('cross').addClass(myClas = ['circle', ' cross'][turn]).html('<div></div>');
        $('#turnIcon.circle div').css('border-width', $('#turnIcon.circle').width() / 100 * 20);
      }
    });
    return $(window).resize(function() {
      var boardSize;
      boardSize = $(window).height() / 100 * 80;
      $('.gameBoard').css({
        'height': boardSize + 'px',
        'width': boardSize + 'px'
      });
      $('.circle div').css('border-width', $('.cell').height() / 100 * 20);
      return $('#turnIcon.circle div').css('border-width', $('#turnIcon.circle').width() / 100 * 20);
    }).load(function() {
      var boardSize;
      boardSize = $(window).height() / 100 * 80;
      return $('.gameBoard').css({
        'height': boardSize + 'px',
        'width': boardSize + 'px'
      });
    });
  });

}).call(this);
