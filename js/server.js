// Generated by CoffeeScript 1.8.0
(function() {
  var app, express;

  express = require('express');

  app = express.createServer();

  app.listen(3000);

  app.get('/', function() {
    return b.send('Hello');
  });

}).call(this);
