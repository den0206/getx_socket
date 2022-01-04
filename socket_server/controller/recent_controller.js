const Recent = require('../model/recent');
const {encodeBase64, decodeToBase64} = require('../utils/base64');

async function createPrivateChat(req, res) {
  const body = req.body;

  const recent = new Recent({
    userId: body.userId,
    chatRoomId: body.chatRoomId,
    withUserId: body.withUserId,
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
  console.log(limit);
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

async function findByRoomId(req, res) {
  const chatRoomid = req.params.chatRoomId;

  const recents = await Recent.find({chatRoomId: chatRoomid});

  try {
    res.status(200).json({status: true, data: recents});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not get Recents'});
  }
}

module.exports = {
  createPrivateChat,
  findByUserId,
  findByRoomId,
};
