var socket = require('socket.io');

function connectIO(server) {
  var io = socket(server);

  var messageIO = io.of('/messages');
  var recentIO = io.of('/recents');

  /// Message_namespace

  messageIO.on('connection', (socket) => {
    console.log('CHAT connected', socket.id);

    chatID = socket.handshake.query.chatID;
    socket.join(chatID);

    socket.on('message', (msg) => {
      messageIO.in(chatID).emit('message-receive', msg);
    });

    socket.on('read', (ids) => {
      messageIO.in(chatID).emit('read-receive', ids);
    });

    /// connect another namespace
    socket.on('update', (data) => {
      roomIds = data['userIds'];
      roomIds.forEach(function (room) {
        recentIO.to(room).emit('update', data);
      });

      /// notWOrk
      // recentIO.in(roomIds).emit('update', data);
    });

    socket.on('disconnect', () => {
      socket.leave(chatID, function (err) {
        console.log(socket.adapter.rooms); // display the same list of rooms the specified room is still there
      });
      console.log('Chat Disconnrect');
    });
  });

  /// Recent_namespace

  recentIO.on('connection', (socket) => {
    console.log('RECENT Connected', socket.id);
    userId = socket.handshake.query.userId;

    socket.join(userId);

    socket.on('singleRecent', (data) => {
      userId = data['userId'];
      recentIO.to(userId).emit('update', data);
    });

    socket.on('updateFromBegin', (data) => {
      roomIds = data['userIds'];

      roomIds.forEach(function (room) {
        recentIO.to(room).emit('update', data);
      });
    });

    socket.on('disconnect', () => {
      console.log('Recent Disconnrect');
    });
  });
}

module.exports = connectIO;

// io.on('connection', (socket) => {
//   console.log('connected', socket.id);

//   chatID = socket.handshake.query.chatID;

//   socket.join(chatID);
//   console.log(socket.adapter.rooms);

//   socket.on('message', (msg) => {
//     io.in(chatID).emit('message-receive', msg);

//     // socket.broadcast.emit('message-receive', msg);
//   });

//   socket.on('disconnect', () => {
//     socket.leave(chatID, function (err) {
//       console.log(socket.adapter.rooms); // display the same list of rooms the specified room is still there
//     });
//     console.log('Disconnrect');
//   });
// });
