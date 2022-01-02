const User = require('../model/user');
const jwt = require('jsonwebtoken');
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

module.exports = {signUp, login};
