var http = require('http');

var server = http.createServer(function(req, res) {
res.writeHead(200);
res.end('Hi there form nodejs behind nginx! try add "/static/style.css" to see nginx is serving it!');
});
server.listen(3000);