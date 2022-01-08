const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const messageSchema = mongoose.Schema({
  chatRoomId: {type: String, required: true},
  text: {type: String, required: true},
  userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
  readBy: [{type: mongoose.Schema.Types.ObjectId, ref: 'User'}],
  date: {type: Date, default: Date.now},
});

messageSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

messageSchema.set('toJSON', {
  virtuals: true,
});

messageSchema.plugin(uniqueValidator);

const Message = mongoose.model('Message', messageSchema);

module.exports = Message;
