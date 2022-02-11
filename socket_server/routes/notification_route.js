const express = require('express');
const router = express.Router();
const {checkAuth} = require('../middleware/check_auth');

const notificationController = require('../controller/notification_controller');

router.post('/', notificationController.pushNotification);
router.get('/getBadgeCount', checkAuth, notificationController.getBadgeCount);

module.exports = router;
