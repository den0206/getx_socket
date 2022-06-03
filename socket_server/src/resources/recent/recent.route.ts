import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import recentController from './recent.controller';

const recentRoute = Router();
// recentRoute.use(checkAuth);
recentRoute.post('/', recentController.createChatRecent);

recentRoute.get('/userid', checkAuth, recentController.findByUserId);
recentRoute.get('/roomid', checkAuth, recentController.findByRoomId);
recentRoute.get('/one', checkAuth, recentController.findOneByRoomAndUser);

recentRoute.put('/update', checkAuth, recentController.updateRecent);
recentRoute.delete('/:id', checkAuth, recentController.deleteRecent);

export default recentRoute;
