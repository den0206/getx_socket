import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';
import {UserModel, TempTokenModel} from '../../utils/database/models';
import sendEmail from '../../utils/email/send_email';

// Email

async function requestNewEmail(req: Request, res: Response) {
  const {email} = req.body;

  try {
    const isFind = await UserModel.findOne({email});
    if (isFind)
      return new ResponseAPI(res, {message: 'Already Use Thie Email'}).excute(
        400
      );

    const genetateNumber = await generateNumberAndToken(email);
    const payload = {email: email, number: genetateNumber};
    await sendEmail(
      email,
      'Email Confirmation',
      payload,
      '../email/template/requestCheckEmail.handlebars'
    );
    new ResponseAPI(res, {data: 'Send Change Email'}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function verifyEmail(req: Request, res: Response) {
  const {email, verify} = req.body;
  try {
    const newEmailToken = await checkValid(email, verify);
    await sendEmail(
      email,
      'Confirm Email Successfully',
      {email: email},
      '../email/template/checkEmail.handlebars'
    );

    await newEmailToken.deleteOne();
    new ResponseAPI(res, {data: 'Success Valid Email'}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

// password
async function requestPassword(req: Request, res: Response) {
  const {email} = req.body;
  try {
    const isFind = await UserModel.findOne({email});
    if (!isFind)
      return new ResponseAPI(res, {message: 'Not find this Email'}).excute(400);

    const genetateNumber = await generateNumberAndToken(isFind._id);
    const payload = {name: isFind.name, number: genetateNumber};

    await sendEmail(
      email,
      'Password Reset Request',
      payload,
      '../email/template/requestResetPassword.handlebars'
    );

    new ResponseAPI(res, {data: 'Send Change Password'}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function verifyPassword(req: Request, res: Response) {
  const {userId, password, verify} = req.body;
  try {
    const passwordResetToken = await checkValid(userId, verify);
    const newUser = await UserModel.findByIdAndUpdate(
      userId,
      {$set: {password}},
      {new: true}
    );
    if (!newUser)
      return new ResponseAPI(res, {message: 'Not find the User'}).excute(400);

    await sendEmail(
      newUser.email,
      'Password Reset Successfully',
      {name: newUser.name},
      '../email/template/resetPassword.handlebars'
    );

    await passwordResetToken.deleteOne();

    new ResponseAPI(res, {data: 'Success Valid Email'}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

// commone Functions
async function generateNumberAndToken(tempId: string) {
  const token = await TempTokenModel.findOne({tempId});
  if (token) await token.deleteOne();
  const generateNumber = Math.floor(100000 + Math.random() * 900000);
  const newToken = new TempTokenModel({
    tempId,
    token: generateNumber,
    createdAt: Date.now(),
  });

  await newToken.save();
  return generateNumber;
}

async function checkValid(tempId: string, verify: string) {
  const currentToken = await TempTokenModel.findOne({tempId: tempId});
  if (!currentToken) throw new Error('Invalid or expired password reset token');
  const isValid = await currentToken.compareToken(verify);
  if (!isValid) throw new Error('Invalid or expired password reset token');
  return currentToken;
}

export default {
  requestNewEmail,
  verifyEmail,
  requestPassword,
  verifyPassword,
};
