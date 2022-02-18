const mongoose = require('mongoose');

const tokenSchema = mongoose.Schema({
  tempId: {
    type: String,
    unique: true,
    required: true,
  },
  token: {type: String, required: true},
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
});

const TempToken = mongoose.model('TempToken', tokenSchema);
module.exports = TempToken;
