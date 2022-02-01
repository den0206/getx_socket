const express = require('express');
const router = express.Router();
const {checkAuth} = require('../middleware/check_auth');

const translateController = require('../controller/translate_controller');

router.get('/', checkAuth, translateController.textTR);

module.exports = router;
