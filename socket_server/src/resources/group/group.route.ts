import {Router} from 'express';
import groupController from './group.controller';
import checkAuth from '../../middleware/check_auth';

const groupRoute = Router();

groupRoute.use(checkAuth);
groupRoute.post('/', groupController.createGroup);
groupRoute.get('/userId', groupController.findByUserId);
groupRoute.put('/leave', groupController.leaveTheGroup);

groupRoute.delete('/delete', groupController.deleteGroup);

export default groupRoute;
