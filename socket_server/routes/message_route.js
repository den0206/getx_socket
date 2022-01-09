const express = require('express');
const router = express.Router();
const messageController = require('../controller/message_controller');
const {checkAuth} = require('../middleware/check_auth');

router.get('/:chatRoomId', messageController.loadMessage);
router.post('/', messageController.sendMessage);

module.exports = router;
