import {Router} from 'express';
import messageController from './message.controller';
import checkAuth from '../../middleware/check_auth';
import upload from '../../utils/aws/upload_option';

const messageRoute = Router();

messageRoute.get('/load', checkAuth, messageController.loadMessage);
// Text
messageRoute.post('/', checkAuth, messageController.sendMessage);

// Image
messageRoute.post(
  '/image',
  checkAuth,
  upload.single('image'),
  messageController.sendImageMessage
);

// Video
messageRoute.post(
  '/video',
  checkAuth,
  upload.array('video'),
  messageController.sendVideoMessage
);

messageRoute.put('/updateRead', checkAuth, messageController.updateReadStatus);
messageRoute.delete('/delete', checkAuth, messageController.deleteMessage);

export default messageRoute;
