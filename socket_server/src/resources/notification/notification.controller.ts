import axios, {RawAxiosRequestConfig} from 'axios';
import {Request, Response} from 'express';
import mongoose from 'mongoose';
import getUserIdFromRes from '../../middleware/get_userid_res';
import {RecentModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';

async function pushNotification(req: Request, res: Response) {
  const fcmURL = 'https://fcm.googleapis.com/fcm';
  const serverKey = process.env.FCM_SERVER_KEY;
  const client = axios.create({baseURL: fcmURL, proxy: false});

  const headers = {
    'Content-Type': 'application/json',
    Authorization: `key=${serverKey}`,
  };

  const options: RawAxiosRequestConfig = {
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

    if (count.length < 1) return new ResponseAPI(res, {data: 0}).excute(200);
    const total = count[0].counter as number;

    return res.status(200).json({status: true, data: total});
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {
  pushNotification,
  getBadgeCount,
};
