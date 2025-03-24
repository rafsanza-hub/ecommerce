const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const authHeader  = req.header('Authorization');

  if (!authHeader ) {
    return res.status(401).json({ message: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch (error) {
    return res.status(403).json({ message: 'Invalid token', error: error.message });
  }
};

module.exports = verifyToken;
