var socket = require('socket.io');

function connectIO(server) {
  var io = socket(server);
  var clients = {};

  io.on('connection', (socket) => {
    console.log('connected', socket.id);

    chatID = socket.handshake.query.chatID;
    socket.join(chatID);

    socket.on('message', (msg) => {
      io.in(chatID).emit('message-receive', msg);

      // socket.broadcast.emit('message-receive', msg);
    });

    socket.on('disconnect', () => {
      console.log('Disconnrect');
    });
  });
}

module.exports = connectIO;
