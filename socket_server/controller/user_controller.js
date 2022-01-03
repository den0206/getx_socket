const User = require('../model/user');
const jwt = require('jsonwebtoken');
const {encodeBase64, decodeToBase64} = require('../utils/base64');

const bcrypt = require('bcrypt');

async function signUp(req, res, next) {
  const body = req.body;
  console.log(body);
  const isFind = await User.findOne({email: body.email});

  if (isFind)
    return res
      .status(400)
      .json({status: false, message: 'Already Email Exist'});

  const hashed = await bcrypt.hash(body.password, 10);

  const user = new User({
    name: body.name,
    email: body.email,
    password: hashed,
  });

  try {
    await user.save();
    res.status(200).json({status: true, data: user});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not create user'});
  }
}

async function login(req, res) {
  const email = req.body.email;
  const password = req.body.password;

  const user = await User.findOne({email: email});

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

module.exports = {signUp, login, getUsers};
