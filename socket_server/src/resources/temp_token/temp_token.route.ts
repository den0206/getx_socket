import {Router} from 'express';
import tempTokenController from './temp_token.controller';

const tokenRoute = Router();

tokenRoute.post('/requestNewEmail', tempTokenController.requestNewEmail);
tokenRoute.post('/verifyEmail', tempTokenController.verifyEmail);
tokenRoute.post('/requestPassword', tempTokenController.requestPassword);
tokenRoute.post('/verifyPassword', tempTokenController.verifyPassword);

export default tokenRoute;
