import {Response} from 'express';

export default function getUserIdFromRes(res: Response): string {
  return res.locals.user.userid;
}
