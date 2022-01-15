const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const recentSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  chatRoomId: {type: String, required: true},
  withUserId: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
  group: {type: mongoose.Schema.Types.ObjectId, ref: 'Group'},
  lastMessage: {type: String, default: ''},
  counter: {type: Number, default: 0},
  date: {type: Date, default: Date.now},
});

// ,
//   {timestamps: true}

recentSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

recentSchema.set('toJSON', {
  virtuals: true,
});

recentSchema.plugin(uniqueValidator);

const Recent = mongoose.model('Recent', recentSchema);
module.exports = Recent;
