module.exports.encodeBase64 = (data) => Buffer.from(data).toString('base64');
module.exports.decodeToBase64 = (data) =>
  Buffer.from(data, 'base64').toString('ascii');
