const express = require('express');
const router = express.Router();
const messageController = require('../controller/message_controller');
const {checkAuth} = require('../middleware/check_auth');
var multer = require('multer');
const upload = require('../aws/upload_option');

router.get('/:chatRoomId', messageController.loadMessage);

// Text
router.post('/', messageController.sendMessage);
// Image
router.post(
  '/image',
  upload.single('image'),
  messageController.sendImageMessage
);
// Video
router.post(
  '/video',
  upload.array('video', 2),
  messageController.sendVideoMessage
);

router.delete('/:id', checkAuth, messageController.deleteMessage);

router.put('/updateRead/:id', messageController.updateReadStatus);

module.exports = router;
