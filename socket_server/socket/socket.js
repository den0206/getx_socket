var socket = require('socket.io');

function connectIO(server) {
  var io = socket(server);
  var clients = {};

  io.on('connection', (socket) => {
    console.log('connected', socket.id);

    chatID = socket.handshake.query.chatID;

    socket.join(chatID);
    // console.log(socket.adapter.rooms);

    socket.on('message', (msg) => {
      io.in(chatID).emit('message-receive', msg);

      // socket.broadcast.emit('message-receive', msg);
    });

    socket.on('disconnect', () => {
      socket.leave(chatID, function (err) {
        console.log(socket.adapter.rooms); // display the same list of rooms the specified room is still there
      });
      console.log('Disconnrect');
    });
  });
}

module.exports = connectIO;
