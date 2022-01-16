const jwt = require('jsonwebtoken');

function checkAuth(req, res, next) {
  const bearerHeader = req.headers.authorization;

  if (bearerHeader) {
    try {
      const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
      const token = bearerHeader.split(' ')[1];
      const user = jwt.verify(token, secret);
      req.userData = user;

      next();
    } catch (e) {
      console.log(e);
      return res.status(401).json({status: false, message: 'Token Invalid'});
    }
  } else {
    return res.status(403).json({status: false, message: 'No Token'});
  }
}

module.exports = {checkAuth};
