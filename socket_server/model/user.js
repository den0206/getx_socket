const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');
const Message = require('./message');
const Recent = require('./recent');
const Group = require('./group');

const AwsClient = require('../aws/aws_client');

const userSchema = mongoose.Schema({
  name: {type: String, required: true},
  email: {type: String, required: true, unique: true},
  avatarUrl: {type: String},
  fcmToken: {type: String},
  countryCode: {type: String, required: true},
  mainLanguage: {type: String, required: true},
  password: {type: String, required: true},
  blocked: [{type: mongoose.Schema.Types.ObjectId, ref: 'User', default: []}],
});

userSchema.pre('remove', async function (next) {
  console.log('=== Start USER DELETE');
  console.log('DELETE RELATION', this._id);

  // Messageの削除
  await Message.deleteMany({userId: this._id});

  // Recentの削除
  await Recent.deleteMany({userId: this._id});
  await Recent.deleteMany({withUserId: this._id});

  // Groupの削除
  await Group.deleteMany({ownerId: this._id});
  await leaveGroups();

  /// アバターの削除
  if (this.avatarUrl) {
    console.log('DELETE AVATAR RELATION', this._id);
    await AwsClient.deleteImage(this.avatarUrl);
  }
  next();
});

userSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

userSchema.set('toJSON', {
  virtuals: true,
});

userSchema.plugin(uniqueValidator);

const User = mongoose.model('User', userSchema);
module.exports = User;

async function leaveGroups() {
  const groups = await Group.find({members: {$in: [this._id]}});
  console.log(groups);
  // 直列 非同期
  for (const group in groups) {
    let currentMembers = group.members;
    currentMembers = currentMembers.filter((id) => id !== this._id);
    if (currentMembers.length <= 2) {
      // delete(人数が2を切った時)
      await group.delete();
    } else {
      // update member
      const value = {members: currentMembers};
      await Group.findByIdAndUpdate(group._id, value);
    }
  }
}
