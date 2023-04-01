import {Request, Response} from 'express';
import getUserIdFromRes from '../../middleware/get_userid_res';
import {checkMongoId} from '../../utils/database/database';
import {GroupModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';

async function createGroup(req: Request, res: Response) {
  const {ownerId, title, members} = req.body;

  try {
    const group = new GroupModel({ownerId, title, members});

    await group.save();
    new ResponseAPI(res, {data: group}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByUserId(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);

  if (!checkMongoId(userId))
    return new ResponseAPI(res, {message: 'Invalid Id'}).excute(400);
  try {
    const groups = await GroupModel.find({members: {$in: [userId]}}).populate(
      'members',
      '-password'
    );

    new ResponseAPI(res, {data: groups}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function leaveTheGroup(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  const groupId = req.query.groupId as string;
  if (!checkMongoId(groupId))
    return new ResponseAPI(res, {message: 'InvalidId'}).excute(400);

  const findGroup = await GroupModel.findById(groupId);
  if (!findGroup)
    return new ResponseAPI(res, {message: 'Not Find Group'}).excute(400);

  if (findGroup.ownerId == userId)
    return new ResponseAPI(res, {message: 'Owner Cant Leave The Group'}).excute(
      400
    );

  try {
    let currentMembers = findGroup.members;
    currentMembers = currentMembers.filter((i) => String(i) !== userId);
    console.log(currentMembers);

    if (currentMembers.length <= 2) {
      // delete(人数が2を切った時)
      await findGroup.deleteOne();
    } else {
      // update member
      const value = {members: currentMembers};

      await GroupModel.findByIdAndUpdate(groupId, value, {new: true});
    }

    new ResponseAPI(res, {data: findGroup}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteGroup(req: Request, res: Response) {
  const {groupId} = req.query;
  const userId = getUserIdFromRes(res);

  [userId, groupId as string].forEach((id) => {
    if (!checkMongoId(id))
      return new ResponseAPI(res, {message: 'InvalidId'}).excute(400);
  });
  const findGroup = await GroupModel.findById(groupId);

  if (!findGroup || findGroup.ownerId != userId) {
    return new ResponseAPI(res, {message: 'Only Owner Can The Group'}).excute(
      400
    );
  }

  try {
    await findGroup.deleteOne();
    console.log('=== Complete DELETE');
    new ResponseAPI(res, {data: findGroup}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {
  createGroup,
  findByUserId,
  leaveTheGroup,

  deleteGroup,
};
