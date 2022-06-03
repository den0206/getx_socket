import {Namespace} from 'socket.io';

export function messageSocket(messageIO: Namespace, recentIO: Namespace) {
  messageIO.on('connection', (socket) => {
    const q = socket.handshake.query.chatRoomId;
    if (!q) return;
    const chatRoomId = q as string;
    socket.join(chatRoomId);

    socket.on('message', (msg) => {
      messageIO.to(chatRoomId).emit('message-receive', msg);
    });

    socket.on('read', (ids) => {
      messageIO.to(chatRoomId).emit('read-receive', ids);
    });

    socket.on('update_recent', (data) => {
      const roomIds = data['userIds'];
      /// socket.io V4
      recentIO.to(roomIds).emit('update', data);
    });

    socket.on('disconnect', () => {
      socket.leave(chatRoomId);
      console.log('Chat Disconnrect');
    });
  });
}
