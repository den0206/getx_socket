const User = require('../model/user');
const jwt = require('jsonwebtoken');
const {encodeBase64, decodeToBase64} = require('../utils/base64');
const AwsClient = require('../aws/aws_client');

const bcrypt = require('bcrypt');

async function signUp(req, res, next) {
  const body = req.body;
  const file = req.file;

  console.log(body);
  const isFind = await User.findOne({email: body.email});

  if (isFind)
    return res
      .status(400)
      .json({status: false, message: 'Already Email Exist'});

  const hashed = await bcrypt.hash(body.password, 10);

  let user = new User({
    name: body.name,
    email: body.email,
    countryCode: body.countryCode,
    mainLanguage: body.mainLanguage,
    password: hashed,
  });

  try {
    if (file) {
      const extention = file.originalname.split('.').pop();
      const fileName = `${user._id}/avatar/avatar.${extention}`;
      let imagePath = await AwsClient.uploadImage(file, fileName);
      user.avatarUrl = imagePath;
    }

    await user.save();
    res.status(200).json({status: true, data: user});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not create user'});
  }
}

async function login(req, res) {
  const email = req.body.email;
  const password = req.body.password;
  const fcm = req.body.fcm;

  const value = {fcmToken: fcm};

  const user = await User.findOneAndUpdate({email: email}, value, {new: true});

  // const user = await User.findOne({email: email});

  if (!user)
    return res.status(400).json({status: false, message: 'No  Exist Email'});

  const isPasswordValid = await bcrypt.compare(password, user.password);

  if (!isPasswordValid)
    return res.status(400).json({status: false, message: 'Password not match'});

  const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
  const payload = {userid: user.id, email: user.email};
  const token = jwt.sign(payload, secret);

  const data = {user, token};

  return res.status(200).json({status: true, data: data});
}

async function getUsers(req, res) {
  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;
  let query = {};

  if (cursor) {
    query['_id'] = {
      $lt: decodeToBase64(cursor),
    };
  }

  let users = await User.find(query)
    .sort({_id: -1})
    .limit(limit + 1);

  if (!users)
    return res.status(500).json({status: false, message: 'Not find any User'});

  const hasNextPage = users.length > limit;
  users = hasNextPage ? users.slice(0, -1) : users;

  const nextPageCursor = hasNextPage
    ? encodeBase64(users[users.length - 1].id)
    : null;

  const data = {
    pageFeeds: users,
    pageInfo: {
      nextPageCursor: nextPageCursor,
      hasNextPage: hasNextPage,
    },
  };

  res.status(200).json({status: true, data: data});
}

async function updateUser(req, res) {
  // via Token;
  const userId = req.userData.userid;
  const body = req.body;
  const file = req.file;

  try {
    let imagePath = body.avatarUrl;
    if (file) {
      const extention = file.originalname.split('.').pop();
      const fileName = `${userId}/avatar/avatar.${extention}`;
      imagePath = await AwsClient.uploadImage(file, fileName);
    }

    const value = {
      name: body.name,
      blocked: body.blocked,
      avatarUrl: imagePath,
    };

    console.log(value);
    const newUser = await User.findByIdAndUpdate(userId, value, {new: true});

    if (!newUser) {
      res
        .status(400)
        .json({status: false, message: 'Can not fetch edited user'});
    }
    res.status(200).json({status: true, data: newUser});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not edit user'});
  }
}

async function deleteUser(req, res) {
  const userId = req.userData.userid;

  try {
    const findUser = await User.findById(userId);
    if (!findUser)
      res.status(400).json({status: false, message: 'Can not find the user'});

    /// delete with pre reletaion
    await findUser.delete();
    console.log('=== Complete DELETE');
    res.status(200).json({status: true, data: findUser});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not delete user'});
  }
}

async function getBlockUsers(req, res) {
  const userId = req.userData.userid;

  try {
    const findUser = await User.findById(userId).populate(
      'blocked',
      '-password'
    );
    if (!findUser)
      res.status(400).json({status: false, message: 'No Find User'});

    res.status(200).json({status: true, data: findUser.blocked});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not create user'});
  }
}

module.exports = {
  signUp,
  login,
  getUsers,
  updateUser,
  deleteUser,
  getBlockUsers,
};
