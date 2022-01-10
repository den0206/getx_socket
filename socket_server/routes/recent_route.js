const express = require('express');
const router = express.Router();
const recentController = require('../controller/recent_controller');
const {checkAuth} = require('../middleware/check_auth');

router.post('/', recentController.createPrivateChat);

router.get('/userid/:userId', recentController.findByUserId);
router.get('/roomid/:chatRoomId', recentController.findByRoomId);
router.get('/:userId/:chatRoomId', recentController.findOneByRoomIdAndUserId);

router.put('/:id', checkAuth, recentController.updateRecent);
router.delete('/:id', checkAuth, recentController.deleteRecent);

module.exports = router;
