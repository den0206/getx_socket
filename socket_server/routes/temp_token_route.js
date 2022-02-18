const express = require('express');
const router = express.Router();
const tempTokenController = require('../controller/temp_token_controller');

router.post('/requestNewEmail', tempTokenController.requestNewEmail);
router.post('/verifyEmail', tempTokenController.verifyEmail);
router.post('/requestPassword', tempTokenController.requestPassword);
router.post('/verifyPassword', tempTokenController.verifyPassword);

module.exports = router;
