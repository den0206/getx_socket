import axios, {AxiosRequestConfig} from 'axios';
import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';
import getUserIdFromRes from '../../middleware/get_userid_res';
import {RecentModel} from '../../utils/database/models';
import {mongoose} from '@typegoose/typegoose';

async function pushNotification(req: Request, res: Response) {
  const fcmURL = 'https://fcm.googleapis.com/fcm';
  const serverKey = process.env.FCM_SERVER_KEY;
  const client = axios.create({baseURL: fcmURL, proxy: false});

  const headers = {
    'Content-Type': 'application/json',
    Authorization: `key=${serverKey}`,
  };

  const options: AxiosRequestConfig = {
    method: 'POST',
    headers,
  };

  try {
    const response = await client.post('/send', req.body, options);
    new ResponseAPI(res, {data: response.data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getBadgeCount(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  try {
    const count = await RecentModel.aggregate([
      {$match: {userId: new mongoose.Types.ObjectId(userId)}},
      {$group: {_id: null, counter: {$sum: '$counter'}}},
    ]);

    if (count.length < 1) res.status(200).json({status: true, data: 0});
    const total = count[0].counter;
    new ResponseAPI(res, {data: total}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {
  pushNotification,
  getBadgeCount,
};
