const mongoose = require('mongoose');
const Recent = require('../model/recent');

const fcmURL = 'https://fcm.googleapis.com/fcm';
const serverKey = process.env.FCM_SERVER_KEY;

const axios = require('axios').create({
  baseURL: fcmURL,
  proxy: false,
  // responseType: 'json',
});

async function pushNotification(req, res) {
  const headers = {
    'Content-Type': 'application/json',
    Authorization: `key=${serverKey}`,
  };

  try {
    const response = await axios.post('/send', req.body, {headers: headers});
    res.status(200).json({status: true, data: response.data});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: e.message});
  }
}

async function getBadgeCount(req, res) {
  const current = req.userData.userid;
  try {
    const count = await Recent.aggregate([
      {$match: {userId: mongoose.Types.ObjectId(current)}},
      {$group: {_id: null, counter: {$sum: '$counter'}}},
    ]);

    if (count.length < 1) res.status(200).json({status: true, data: 0});

    const total = count[0].counter;

    res.status(200).json({status: true, data: total});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {pushNotification, getBadgeCount};
