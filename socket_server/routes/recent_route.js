const express = require('express');
const router = express.Router();
const recentController = require('../controller/recent_controller');

router.post('/', recentController.createPrivateChat);
router.get('/userid/:userId', recentController.findByUserId);
router.get('/roomid/:chatRoomId', recentController.findByRoomId);

module.exports = router;
