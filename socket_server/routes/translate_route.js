const express = require('express');
const router = express.Router();
const translateController = require('../controller/translate_controller');

router.get('/', translateController.textTR);

module.exports = router;
