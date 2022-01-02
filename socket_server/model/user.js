const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const userSchema = mongoose.Schema({
  name: {type: String, required: true},
  email: {type: String, required: true, unique: true},
  password: {type: String, required: true},
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
