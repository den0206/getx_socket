const express = require('express');
const router = express.Router();
const userController = require('../controller/user_controller');
const {checkAuth} = require('../middleware/check_auth');
const upload = require('../aws/upload_option');

router.post('/signup', userController.signUp);
router.post('/login', userController.login);
router.get('/', userController.getUsers);

router.put(
  '/edit',
  checkAuth,
  upload.single('image'),
  userController.updateUser
);

router.delete('/delete', checkAuth, userController.deleteUser);

module.exports = router;
