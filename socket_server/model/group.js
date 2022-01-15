const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const groupSchema = mongoose.Schema({
  ownerId: {type: String, required: true},
  title: {type: String},
  members: [
    {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
  ],
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
