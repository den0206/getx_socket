import {Response, Request, NextFunction} from 'express';
import ResponseAPI from '../utils/interface/response.api';

export default function checkAPIKey(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const apiKey = req.headers['x-api-key'];
  if (apiKey != process.env.API_KEY) {
    new ResponseAPI(res, {message: 'No API Key'}).excute(401);
  } else {
    next();
  }
}
