const mongoose = require('mongoose');

const tokenSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: 'User',
  },
  token: {type: String, required: true},
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
});

const ResetPassword = mongoose.model('ResetPassword', tokenSchema);
module.exports = ResetPassword;
