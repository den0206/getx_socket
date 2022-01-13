const express = require('express');
const router = express.Router();
const messageController = require('../controller/message_controller');
const {checkAuth} = require('../middleware/check_auth');

router.get('/:chatRoomId', messageController.loadMessage);
router.post('/', messageController.sendMessage);
router.delete('/:id', checkAuth, messageController.deleteMessage);

router.put('/updateRead/:id', messageController.updateReadStatus);

module.exports = router;
