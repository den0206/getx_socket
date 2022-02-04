const express = require('express');
const router = express.Router();
const userController = require('../controller/user_controller');
const {checkAuth} = require('../middleware/check_auth');
const upload = require('../aws/upload_option');

router.post('/signup', upload.single('image'), userController.signUp);
router.post('/login', userController.login);
router.get('/', userController.getUsers);

router.put(
  '/edit',
  checkAuth,
  upload.single('image'),
  userController.updateUser
);

router.get('/blocks', checkAuth, userController.getBlockUsers);
router.delete('/delete', checkAuth, userController.deleteUser);

module.exports = router;
