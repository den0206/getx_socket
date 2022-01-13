const Message = require('../model/message');
const {encodeBase64, decodeToBase64} = require('../utils/base64');
const {checkId} = require('../db/database');

async function loadMessage(req, res) {
  const chatRoomId = req.params.chatRoomId;

  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {chatRoomId: chatRoomId};

  if (cursor) {
    query['_id'] = {
      $lt: decodeToBase64(cursor),
    };
  }

  let messages = await Message.find(query)
    .sort({_id: -1})
    .limit(limit + 1)
    .populate('userId', '-password');
  // .populate('readBy', 'select');

  const hasNextPage = messages.length > limit;
  messages = hasNextPage ? messages.slice(0, -1) : messages;

  const nextPageCursor = hasNextPage
    ? encodeBase64(messages[messages.length - 1].id)
    : null;

  const data = {
    pageFeeds: messages,
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

async function sendMessage(req, res) {
  const body = req.body;

  const message = new Message({
    chatRoomId: body.chatRoomId,
    text: body.text,
    userId: body.userId,
  });

  try {
    await message.save();
    res.status(200).json({status: true, data: message});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not create Message'});
  }
}

async function updateReadStatus(req, res) {
  const id = req.params.id;
  const readBy = req.body.readBy;

  console.log(id, readBy);

  if (!checkId(id))
    return res.status(400).json({status: false, message: 'Invalid id'});

  const value = {readBy: readBy};

  try {
    const _ = await Message.findByIdAndUpdate(id, value);
    res.status(200).json({status: true, message: 'Success,Update Read'});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not update Read'});
  }
}

async function deleteMessage(req, res) {
  const id = req.params.id;

  if (!checkId(id))
    return res
      .status(400)
      .json({status: false, message: 'Invalid Chat Room Id'});

  try {
    /// もし既にメッセージが消されている場合,dataはnullで返却される。
    const mes = await Message.findByIdAndUpdate(id);
    res.status(200).json({status: true, data: mes});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {loadMessage, sendMessage, updateReadStatus, deleteMessage};
