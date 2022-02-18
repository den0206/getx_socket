const User = require('../model/user');
const TempToken = require('../model/temp_token');
const {sendEmail} = require('../utils/email/send_email');
const bcrypt = require('bcrypt');

// Email

async function requestNewEmail(req, res) {
  const {email} = req.body;

  try {
    const isFind = await User.findOne({email: email});
    if (isFind)
      return res
        .status(400)
        .json({status: false, message: 'Already Use Thie Email'});

    const genetateNumber = await generateNumberAndToken(email);
    const payload = {email: email, number: genetateNumber};

    await sendEmail(
      email,
      'Email Confirmation',
      payload,
      '../email/template/requestCheckEmail.handlebars'
    );

    res.status(200).json({status: true, data: 'ConfirmEmail'});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function verifyEmail(req, res) {
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
    res.status(200).json({status: true, data: 'Success Confirm'});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

// Password
async function requestPassword(req, res) {
  const {email} = req.body;

  try {
    const isFind = await User.findOne({email: email});
    if (!isFind)
      return res
        .status(400)
        .json({status: false, message: 'Not find this Email'});

    const genetateNumber = await generateNumberAndToken(isFind._id);

    const payload = {name: isFind.name, number: genetateNumber};

    await sendEmail(
      email,
      'Password Reset Request',
      payload,
      '../email/template/requestResetPassword.handlebars'
    );

    res.status(200).json({status: true, data: isFind._id});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function verifyPassword(req, res) {
  const {userId, password, verify} = req.body;
  try {
    const passwordResetToken = await checkValid(userId, verify);
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.findByIdAndUpdate(
      userId,
      {$set: {password: hashedPassword}},
      {new: true}
    );

    await sendEmail(
      newUser.email,
      'Password Reset Successfully',
      {name: newUser.name},
      '../email/template/resetPassword.handlebars'
    );

    await passwordResetToken.deleteOne();
    res.status(200).json({status: true, data: newUser});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  requestNewEmail,
  verifyEmail,
  requestPassword,
  verifyPassword,
};

// Common Functions

async function generateNumberAndToken(tempId) {
  const token = await TempToken.findOne({tempId: tempId});
  if (token) await token.deleteOne();
  const genetateNumber = Math.floor(100000 + Math.random() * 900000);
  const hashed = await bcrypt.hash(genetateNumber.toString(), 10);

  const newToken = TempToken({
    tempId: tempId,
    token: hashed,
    createdAt: Date.now(),
  });

  await newToken.save();

  return genetateNumber;
}

async function checkValid(tempId, verify) {
  const currentToken = await TempToken.findOne({tempId: tempId});
  if (!currentToken) throw new Error('Invalid or expired password reset token');
  const isValid = await bcrypt.compare(verify, currentToken.token);
  if (!isValid) throw new Error('Invalid or expired password reset token');

  return currentToken;
}
