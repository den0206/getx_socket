import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import notificationController from './notification.controller';

const notificationRoute = Router();

notificationRoute.post('/', notificationController.pushNotification);

notificationRoute.get(
  '/getBadgeCount',
  checkAuth,
  notificationController.getBadgeCount
);

export default notificationRoute;
