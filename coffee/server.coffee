express = require 'express'
app = express.createServer()
app.listen 3000

app.get '/', ->
  b.send 'Hello'

