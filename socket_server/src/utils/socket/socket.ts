import {Server} from 'http';
import socket from 'socket.io';
import {messageSocket} from './message_io';
import {recentSocket} from './recent_io';

export function connectIO(server: Server) {
  const local = process.env.LOCAL;

  const io = new socket.Server(server, {cors: {origin: local}});
  const messageIO = io.of('/messages');
  const recentIO = io.of('/recents');

  messageSocket(messageIO, recentIO);
  recentSocket(recentIO);
}
