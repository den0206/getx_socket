import {Response, Request, NextFunction} from 'express';
import jwt from 'jsonwebtoken';
import ResponseAPI from '../utils/interface/response.api';

export default function checkAuth(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const bearerHeader = req.headers.authorization;

  if (bearerHeader) {
    try {
      const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
      const token = bearerHeader.split(' ')[1];
      const decorded = jwt.verify(token, secret);

      res.locals.user = decorded;
      next();
    } catch (e: any) {
      return new ResponseAPI(res, {message: 'Token Expire'}).excute(403);
    }
  } else {
    return new ResponseAPI(res, {message: 'No Token'}).excute(403);
  }
}
