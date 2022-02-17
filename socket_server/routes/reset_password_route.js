const express = require('express');
const router = express.Router();
const resetPasswordController = require('../controller/reset_password_controller');

router.post('/request', resetPasswordController.request);
router.post('/verify', resetPasswordController.verify);

module.exports = router;
