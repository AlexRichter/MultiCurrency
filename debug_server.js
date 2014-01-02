var express = require('express');
var app = express();

app.set('port', 3000);
app.use(express.static(__dirname + '/debug'));
app.listen(3000);
console.log("Starting server on 3000");