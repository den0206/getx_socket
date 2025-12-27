import {Request, Response} from 'express';
import {PopulateOptions} from 'mongoose';
import getUserIdFromRes from '../../middleware/get_userid_res';
import {checkMongoId} from '../../utils/database/database';
import {RecentModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';

const recentOpt: PopulateOptions[] = [
  {
    path: 'userId',
    model: 'User',
  },
  {
    path: 'withUserId',
    model: 'User',
  },
  {
    path: 'group',
    model: 'Group',
    populate: {path: 'members', model: 'User'},
  },
];

async function createChatRecent(req: Request, res: Response) {
  const {userId, chatRoomId, withUserId, group} = req.body;

  const recent = new RecentModel({userId, chatRoomId, withUserId, group});

  try {
    await recent.save();
    new ResponseAPI(res, {data: recent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByUserId(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);

  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

  try {
    const data = await usePagenation({
      model: RecentModel,
      limit,
      cursor,
      opt: recentOpt,
      specific: {userId},
    });

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateRecent(req: Request, res: Response) {
  const recentId = req.query.id as string;
  const {lastMessage, counter} = req.body;

  if (!checkMongoId(recentId))
    return new ResponseAPI(res, {message: 'Invalid RecentId'}).excute(400);

  try {
    const value = {lastMessage, counter, date: Date.now()};
    const updateRecent = await RecentModel.findByIdAndUpdate(recentId, value, {
      new: true,
    });

    if (!updateRecent)
      return new ResponseAPI(res, {message: 'Cant find recent'}).excute(400);

    new ResponseAPI(res, {data: updateRecent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByRoomId(req: Request, res: Response) {
  const chatRoomId = req.query.chatRoomId as string;
  const useUserParam = req.query.userParams as string;

  let recents;

  /// 使う(private) 0
  /// 使わない 1
  try {
    switch (useUserParam) {
      case '0':
        recents = await RecentModel.find({chatRoomId}).populate(recentOpt);

        break;
      case '1':
        recents = await RecentModel.find({chatRoomId});
        break;
      default:
        return new ResponseAPI(res, {message: 'unknown query'}).excute(400);
    }

    new ResponseAPI(res, {data: recents}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findOneByRoomAndUser(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  const chatRoomId = req.query.chatRoomId as string;

  try {
    const findRecent = await RecentModel.findOne({userId: userId as any, chatRoomId}).populate(
      recentOpt
    );
    if (!findRecent)
      return new ResponseAPI(res, {message: 'not find Recent'}).excute(400);

    new ResponseAPI(res, {data: findRecent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteRecent(req: Request, res: Response) {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const userId = getUserIdFromRes(res);
  const recentId = req.params.id;
  try {
    console.log('Success Delete Recent');
    const recent = await RecentModel.findByIdAndDelete(recentId);
    new ResponseAPI(res, {data: recent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {
  createChatRecent,
  findByUserId,
  updateRecent,
  deleteRecent,

  findByRoomId,
  findOneByRoomAndUser,
};
