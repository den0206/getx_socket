const Message = require('../model/message');

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

module.exports = {sendMessage};
