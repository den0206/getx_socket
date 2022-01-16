const express = require('express');
const router = express.Router();
const groupController = require('../controller/group_controller');
const {checkAuth} = require('../middleware/check_auth');

router.post('/', groupController.createGroup);
router.get('/:userId', groupController.findByUserId);

module.exports = router;
