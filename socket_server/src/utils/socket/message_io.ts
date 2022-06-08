import {Namespace} from 'socket.io';

export function messageSocket(messageIO: Namespace, recentIO: Namespace) {
  messageIO.on('connection', (socket) => {
    const q = socket.handshake.query.chatRoomId;
    if (!q) return;
    const chatRoomId = q as string;
    socket.join(chatRoomId);
    console.log('Chat In', chatRoomId);

    socket.on('new_message', (msg) => {
      messageIO.to(chatRoomId).emit('new_message', msg);
    });

    socket.on('read', (ids) => {
      messageIO.to(chatRoomId).emit('read', ids);
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
