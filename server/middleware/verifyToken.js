const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
        return res.status(401).json({ message: "Authorization header is missing or malformed!" });
    }
    

    const token = req.headers.authorization.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: "Token is not provided in the Authorization header!" });
    }

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
        req.userData = { userId: decodedToken.userId };
        next();
    } catch (error) {
        console.log(`JWT Error: ${error.message}`); // Log to diagnose
        return res.status(401).json({ message: "Failed to authenticate token!" });
    }
};

module.exports = verifyToken;
