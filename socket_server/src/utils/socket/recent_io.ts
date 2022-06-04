import {Namespace} from 'socket.io';

export function recentSocket(recentIO: Namespace) {
  recentIO.on('connection', (socket) => {
    const q = socket.handshake.query.userId;
    if (!q) return;
    const userId = q as string;
    console.log('Recent user id', userId);
    socket.join(userId);

    socket.on('update', (data) => {
      const roomIds = data['userIds'];
      console.log(`Roomids ${roomIds}`);
      // multiple
      recentIO.to(roomIds).emit('update', data);
    });

    socket.on('deleteGroup', (data) => {
      const roomIds = data['userIds'];
      // multiple
      recentIO.to(roomIds).emit('delete', data);
    });

    socket.on('disconnect', () => {
      socket.leave(userId);
      console.log('Recent Disconnrect');
    });
  });
}
