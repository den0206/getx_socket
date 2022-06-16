import {Router} from 'express';
import reportController from './report.controller';
import checkAuth from '../../middleware/check_auth';

const reportRoute = Router();
reportRoute.post('/create', checkAuth, reportController.reportUser);

export default reportRoute;
