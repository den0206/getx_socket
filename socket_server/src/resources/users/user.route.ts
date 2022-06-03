import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import upload from '../../utils/aws/upload_option';

import userController from './user.controller';

const usersRoute = Router();

usersRoute.post('/signup', upload.single('image'), userController.signUp);
usersRoute.post('/login', userController.login);
usersRoute.get('/', checkAuth, userController.getUsers);

usersRoute.put(
  '/edit',
  checkAuth,
  upload.single('image'),
  userController.updateUser
);
usersRoute.delete('/delete', checkAuth, userController.deleteUser);
usersRoute.get('/blocks', checkAuth, userController.blockUsers);

usersRoute.get('/search', checkAuth, userController.getById);

export default usersRoute;
