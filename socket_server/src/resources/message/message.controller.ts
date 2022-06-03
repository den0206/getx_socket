import {Request, Response} from 'express';
import {usePagenation} from '../../utils/database/pagenation';
import {MessageModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import getUserIdFromRes from '../../middleware/get_userid_res';
import {checkMongoId} from '../../utils/database/database';
import AWSClient from '../../utils/aws/aws_client';

async function loadMessage(req: Request, res: Response) {
  const chatRoomId = req.query.chatRoomId as string;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

  try {
    const data = await usePagenation({
      model: MessageModel,
      limit,
      cursor,
      specific: {chatRoomId},
      pop: 'userId',
      exclued: 'password',
    });

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function sendMessage(req: Request, res: Response) {
  const {chatRoomId, text, translated, userId} = req.body;

  try {
    const message = new MessageModel({chatRoomId, text, translated, userId});
    await message.save();
    new ResponseAPI(res, {data: message}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function sendImageMessage(req: Request, res: Response) {
  const {chatRoomId, text, userId} = req.body;
  const file = req.file;

  const message = new MessageModel({userId, chatRoomId, text});

  try {
    if (!file) return new ResponseAPI(res, {message: 'No image'}).excute(400);
    const awsClient = new AWSClient();
    const extention = file.originalname.split('.').pop();
    const fileName = `${message.userId}/messages/${message.id}/image.${extention}`;
    const fileUrl = await awsClient.uploadImagge(file, fileName);
    message.imageUrl = fileUrl;
    await message.save();
    new ResponseAPI(res, {data: message}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function sendVideoMessage(req: Request, res: Response) {
  const {chatRoomId, text, userId} = req.body;
  const files = req.files as Express.Multer.File[];
  const imageMimes = ['image/jpeg', 'image/jpg', 'image/png'];
  const videoMimes = ['video/mp4'];

  const message = new MessageModel({userId, chatRoomId, text});

  try {
    if (!files || !(files.length == 2))
      return new ResponseAPI(res, {message: 'Not find File OR 2'}).excute(400);

    var fileUrls = [];
    const awsClient = new AWSClient();
    for (const file of files) {
      const extention = file.originalname.split('.').pop();
      var fileName;
      if (imageMimes.includes(file.mimetype)) {
        fileName = `${message.userId}/messages/${message.id}/image.${extention}`;
      } else if (videoMimes.includes(file.mimetype)) {
        fileName = `${message.userId}/messages/${message.id}/video.${extention}`;
      } else {
        throw Error('Not Fit Type');
      }

      const fileUrl = await awsClient.uploadImagge(file, fileName);

      fileUrls.push(fileUrl);
    }
    message.videoUrl = fileUrls[0];
    message.imageUrl = fileUrls[1];

    await message.save();
    new ResponseAPI(res, {data: message}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateReadStatus(req: Request, res: Response) {
  const {messageId, readBy} = req.body;
  if (!checkMongoId(messageId))
    return new ResponseAPI(res, {message: 'InvalidId'}).excute(400);

  const value = {readBy};
  try {
    const _ = await MessageModel.findByIdAndUpdate(messageId, value);
    new ResponseAPI(res, {data: true}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteMessage(req: Request, res: Response) {
  const messageId = req.query.messageId as string;
  if (!checkMongoId(messageId))
    return new ResponseAPI(res, {message: 'InvalidId'}).excute(400);

  try {
    const message = await MessageModel.findByIdAndDelete(messageId);
    new ResponseAPI(res, {data: true}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {
  loadMessage,
  sendMessage,
  updateReadStatus,
  sendImageMessage,
  sendVideoMessage,
  deleteMessage,
};
