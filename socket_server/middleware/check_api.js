function checkAPIKey(req, res, next) {
  const apiKey = req.headers['x-api-key'];

  if (apiKey != process.env.API_KEY) {
    res.status(401).json({message: 'No API KEY'});
  } else {
    next();
  }
}

module.exports = {checkAPIKey};
