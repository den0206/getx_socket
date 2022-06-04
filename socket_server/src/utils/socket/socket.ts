import socket from 'socket.io';
import {Server} from 'http';
import {recentSocket} from './recent_io';
import {messageSocket} from './message_io';

export function connectIO(server: Server) {
  const local = process.env.LOCAL;

  const io = new socket.Server(server, {cors: {origin: local}});
  var messageIO = io.of('/messages');
  var recentIO = io.of('/recents');

  messageSocket(messageIO, recentIO);
  recentSocket(recentIO);
}
