const express = require('express');
const router = express.Router();
const userController = require('../controller/user_controller');

router.post('/signup', userController.signUp);
router.post('/login', userController.login);
router.get('/', userController.getUsers);

module.exports = router;
