const User = require('../model/user');
const ResetPassword = require('../model/reset_password');
const {sendEmail} = require('../utils/email/send_email');

const bcrypt = require('bcrypt');

async function request(req, res) {
  const {email} = req.body;

  try {
    const isFind = await User.findOne({email: email});
    if (!isFind)
      return res
        .status(400)
        .json({status: false, message: 'Not find this Email'});

    const token = await ResetPassword.findOne({userId: isFind._id});
    if (token) await token.deleteOne();
    const genetateNumber = Math.floor(Math.random() * 1000000 + 1);
    const hashed = await bcrypt.hash(genetateNumber.toString(), 10);

    const newToken = ResetPassword({
      userId: isFind._id,
      token: hashed,
      createdAt: Date.now(),
    });

    await newToken.save();
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

async function verify(req, res) {
  const {userId, password, verify} = req.body;
  try {
    const passwordResetToken = await ResetPassword.findOne({userId: userId});
    if (!passwordResetToken)
      throw new Error('Invalid or expired password reset token');

    const isValid = await bcrypt.compare(verify, passwordResetToken.token);
    if (!isValid) throw new Error('Invalid or expired password reset token');
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

module.exports = {request, verify};
