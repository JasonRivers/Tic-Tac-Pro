boardRows = ["a","b","c"]
boardCols = [1, 2, 3]

board = (R, C) ->
  results = []
  results = results.concat r+c for r in R for c in C
  results

brd = board boardRows, boardCols

for cell in brd
  textNode = document.createTextNode cell
  node = document.createElement "div"
  node.setAttribute "id", cell
  node.setAttribute "class", "cell"
  node.appendChild textNode
  mb = document.getElementById("mainBoard")
  mb.appendChild(node)
  console.log cell
