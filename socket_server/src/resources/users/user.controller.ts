import {Request, Response} from 'express';
import {UserModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import jwt from 'jsonwebtoken';
import {usePagenation} from '../../utils/database/pagenation';
import {checkMongoId} from '../../utils/database/database';
import getUserIdFromRes from '../../middleware/get_userid_res';
import AWSClient from '../../utils/aws/aws_client';

async function signUp(req: Request, res: Response) {
  const {name, email, countryCode, mainLanguage, password} = req.body;
  const file = req.file;

  const isFind = await UserModel.findOne({email});

  if (isFind)
    return new ResponseAPI(res, {message: 'Already Exist Email'}).excute(400);

  try {
    const user = new UserModel({
      name,
      email,
      countryCode,
      mainLanguage,
      password,
    });

    user.searchId = user.id;

    if (file) {
      const awsClient = new AWSClient();
      const extention = file.originalname.split('.').pop();
      const fileName = `${user._id}/avatar/avatar.${extention}`;
      let imagePath = await awsClient.uploadImagge(file, fileName);
      user.avatarUrl = imagePath;
    }

    await user.save();
    new ResponseAPI(res, {data: user}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function login(req: Request, res: Response) {
  const {email, password, fcm} = req.body;

  const value = {fcmToken: fcm};

  const isFind = await UserModel.findOneAndUpdate({email: email}, value, {
    new: true,
  });
  if (!isFind)
    return new ResponseAPI(res, {message: 'No Exist Email'}).excute(400);

  const isVerify = await isFind.comparePasswrd(password);
  if (!isVerify)
    return new ResponseAPI(res, {message: 'Password not match'}).excute(400);

  try {
    const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
    const expiresIn = process.env.JWT_EXPIRES_IN;
    const payload = {userid: isFind.id, email: isFind.email};
    const token = jwt.sign(payload, secret, {expiresIn: expiresIn});

    const data = {user: isFind, token};
    new ResponseAPI(res, {data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getUsers(req: Request, res: Response) {
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

  try {
    const data = await usePagenation({
      model: UserModel,
      limit,
      cursor,
      select: ['-password', '-fcmToken'],
      specific: {_id: {$ne: []}},
    });
    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateUser(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  const {name, email, searchId, mainLanguage, avatarUrl} = req.body;
  const file = req.file;

  try {
    let imagePath = avatarUrl;
    if (file) {
      const awsClient = new AWSClient();
      const extention = file.originalname.split('.').pop();
      const fileName = `${userId}/avatar/avatar.${extention}`;
      imagePath = await awsClient.uploadImagge(file, fileName);
    }

    const value = {
      name,
      email,
      searchId,
      mainLanguage,
      avatarUrl: imagePath,
    };

    const newUser = await UserModel.findByIdAndUpdate(userId, value, {
      new: true,
    });
    if (!newUser)
      return new ResponseAPI(res, {
        message: 'Can not find edited user',
      }).excute(400);

    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteUser(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  try {
    const isFind = await UserModel.findById(userId);
    if (!isFind)
      return new ResponseAPI(res, {
        message: 'Can not find Delete user',
      }).excute(400);

    await isFind.delete();
    console.log('=== Complete DELETE');

    new ResponseAPI(res, {data: isFind}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateBlock(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  const {blocked} = req.body;

  try {
    const value = {
      blocked,
    };

    const newUser = await UserModel.findByIdAndUpdate(userId, value, {
      new: true,
    });
    if (!newUser)
      return new ResponseAPI(res, {
        message: 'Can not find edited user',
      }).excute(400);

    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function blockUsers(req: Request, res: Response) {
  const userId = getUserIdFromRes(res);
  try {
    const isFind = await UserModel.findById(userId)
      .select('blocked')
      .populate('blocked', '-password');

    if (!isFind)
      return new ResponseAPI(res, {
        message: 'Can not find  User',
      }).excute(400);

    new ResponseAPI(res, {data: isFind.blocked}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getById(req: Request, res: Response) {
  const searchId = req.query.id as string;

  try {
    var findUser;
    if (checkMongoId(searchId)) {
      findUser = await UserModel.findById(searchId).select([
        '-password',
        '-fcmToken',
      ]);
    } else {
      findUser = await UserModel.findOne({searchId}).select([
        '-password',
        '-fcmToken',
      ]);
    }

    if (!findUser)
      return new ResponseAPI(res, {
        message: 'Can not find  User',
      }).excute(400);

    new ResponseAPI(res, {data: findUser}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {
  signUp,
  login,
  getUsers,
  updateUser,
  updateBlock,
  deleteUser,
  blockUsers,
  getById,
};
