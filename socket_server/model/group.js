const mongoose = require('mongoose');
const Recent = require('./recent');

var uniqueValidator = require('mongoose-unique-validator');
const Message = require('./message');

const groupSchema = mongoose.Schema({
  ownerId: {type: String, required: true},
  title: {type: String},
  members: [
    {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
  ],
});
/// Group-削除 with pre reletaion

groupSchema.pre('remove', async function (next) {
  console.log('=== Start DELETE');
  console.log('DELETE RELATION', this._id);

  await Recent.deleteMany({chatRoomId: this._id});
  await Message.deleteMany({chatRoomId: this._id});
  next();
});

groupSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

groupSchema.set('toJSON', {
  virtuals: true,
});

groupSchema.plugin(uniqueValidator);

const Group = mongoose.model('Group', groupSchema);
module.exports = Group;
