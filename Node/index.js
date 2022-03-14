const httpServer = require('http').createServer()
const socketIO = require('socket.io')(httpServer)

socketIO.on('connection', function (client) {
  console.log('Connected...', client.id);

//listens for new messages coming in
  client.on('message', function name(data) {
    console.log(data);
    socketIO.emit('message', data);
  })

//listens when a user is disconnected from the server
  client.on('disconnect', function () {
    console.log('Disconnected...', client.id);
  })

//listens when there's an error detected and logs the error on the console
  client.on('error', function (err) {
    console.log('Error detected', client.id);
    console.log(err);
  })
})

var port = process.env.PORT || 3000;
httpServer.listen(port, function (err) {
  if (err) console.log(err);
  console.log('Listening on port', port);
});
