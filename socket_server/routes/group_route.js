const express = require('express');
const router = express.Router();
const groupController = require('../controller/group_controller');
const {checkAuth} = require('../middleware/check_auth');

router.post('/', groupController.createGroup);
router.get('/:userId', checkAuth, groupController.findByUserId);
router.put('/leave/:groupId', checkAuth, groupController.leaveTheGroup);
router.delete('/:groupId/:ownerId', checkAuth, groupController.deleteGroup);

module.exports = router;
