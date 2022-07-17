import {Request, Response} from 'express';
import {UserModel, ReportModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import getUserIdFromRes from '../../middleware/get_userid_res';
async function reportUser(req: Request, res: Response) {
  const informer = getUserIdFromRes(res);
  const {reported, reportedContent, message} = req.body;

  try {
    const isFind = await UserModel.findById(reported);
    if (!isFind)
      return new ResponseAPI(res, {message: 'No Exist User'}).excute(400);

    const report = new ReportModel({
      informer,
      reported,
      reportedContent,
      message,
    });
    await report.save();
    new ResponseAPI(res, {data: report}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {reportUser};
