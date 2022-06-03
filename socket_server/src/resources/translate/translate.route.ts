import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import translateController from './translate.controller';

const translateRoute = Router();

translateRoute.get('/', checkAuth, translateController.textTR);

export default translateRoute;
