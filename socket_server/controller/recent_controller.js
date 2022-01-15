const Recent = require('../model/recent');
const {encodeBase64, decodeToBase64} = require('../utils/base64');
const {checkId} = require('../db/database');

async function createChatRecent(req, res) {
  const body = req.body;

  const recent = new Recent({
    userId: body.userId,
    chatRoomId: body.chatRoomId,
    withUserId: body.withUserId,
    group: body.group,
  });

  try {
    await recent.save();
    res.status(200).json({status: true, data: recent});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not create user'});
  }
}
async function findByUserId(req, res) {
  const userId = req.params.userId;

  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {userId: userId};

  if (cursor) {
    query['_id'] = {
      $lt: decodeToBase64(cursor),
    };
  }

  let recents = await Recent.find(query)
    .sort({_id: -1})
    .limit(limit + 1)
    .populate(['userId', 'withUserId']);

  const hasNextPage = recents.length > limit;
  recents = hasNextPage ? recents.slice(0, -1) : recents;

  const nextPageCursor = hasNextPage
    ? encodeBase64(recents[recents.length - 1].id)
    : null;

  const data = {
    pageFeeds: recents,
    pageInfo: {
      nextPageCursor: nextPageCursor,
      hasNextPage: hasNextPage,
    },
  };

  try {
    res.status(200).json({status: true, data: data});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not get Recents'});
  }
}
async function updateRecent(req, res) {
  /// TODO UPDATE
  const recentId = req.params.id;

  if (!checkId(recentId))
    return res
      .status(400)
      .json({status: false, message: 'Invalid Chat Room Id'});

  const value = {
    lastMessage: req.body.lastMessage,
    counter: req.body.counter,
    date: Date.now(),
  };

  console.log(value);

  try {
    const updateRecent = await Recent.findByIdAndUpdate(recentId, value, {
      new: true,
    });
    res.status(200).json({status: true, data: updateRecent});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not update Recents'});
  }
}

async function findByRoomId(req, res) {
  const chatRoomid = req.params.chatRoomId;
  const useUserParam = req.query.userParams;

  var recents;

  /// 使う 0
  /// 使わない 1

  switch (useUserParam) {
    case '0':
      recents = await Recent.find({chatRoomId: chatRoomid}).populate([
        'userId',
        'withUserId',
      ]);
      break;
    case '1':
      recents = await Recent.find({chatRoomId: chatRoomid});
      break;

    default:
      res.status(500).json({status: false, message: 'InValid Params'});
  }

  try {
    res.status(200).json({status: true, data: recents});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not get Recents'});
  }
}

async function findOneByRoomIdAndUserId(req, res) {
  const userId = req.params.userId;
  const chatRoomId = req.params.chatRoomId;

  console.log(userId, chatRoomId);

  try {
    const findRecent = await Recent.findOne({
      userId: userId,
      chatRoomId: chatRoomId,
    }).populate(['userId', 'withUserId']);

    if (!findRecent)
      return res
        .status(400)
        .json({status: false, message: 'Can not find The Recent'});

    res.status(200).json({status: true, data: findRecent});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Invlid Error'});
  }
}

async function deleteRecent(req, res) {
  const recentId = req.params.id;
  console.log(req.userData);

  try {
    console.log('Success');
    const recent = await Recent.findByIdAndDelete(recentId);

    res.status(200).json({status: true, data: recent});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  createPrivateChat: createChatRecent,
  updateRecent,
  findByUserId,
  findByRoomId,
  findOneByRoomIdAndUserId,
  deleteRecent,
};
