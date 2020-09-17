const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.hello = functions.https.onRequest((req, res) => {
  // verify user from req.headers.authorization etc.
  res.status(401).send('Authentication required.')
 console.log("pass");
});

