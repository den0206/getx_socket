const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const AwsClient = require('../aws/aws_client');

const messageSchema = mongoose.Schema({
  chatRoomId: {type: String, required: true},
  text: {type: String, required: true},
  userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
  readBy: [{type: mongoose.Schema.Types.ObjectId, ref: 'User', default: []}],
  translated: {type: String},
  imageUrl: {type: String},
  videoUrl: {type: String},
  date: {type: Date, default: Date.now},
});

// Message-削除 with pre reletaion

messageSchema.pre('remove', async function (next) {
  if (this.imageUrl) {
    console.log('=== Start DELETE');
    console.log('DELETE IAMGE RELATION', this._id);
    await AwsClient.deleteImage(this.imageUrl);
  }
  if (this.videoUrl) {
    console.log('=== Start DELETE');
    console.log('DELETE VIDEO RELATION', this._id);
    await AwsClient.deleteImage(this.videoUrl);
  }
  next();
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
