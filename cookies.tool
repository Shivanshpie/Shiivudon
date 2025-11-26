// npm: express cookie-parser jsonwebtoken
const express = require('express');
const cookieParser = require('cookie-parser');
const jwt = require('jsonwebtoken');

const app = express();
app.use(cookieParser());
app.use(express.json());

const JWT_SECRET = 'replace_with_strong_secret';
const SESSION_STORE = {
  // example in-memory session: sessionId -> user data
  'sess123': { userId: 1, username: 'alice' }
};

app.post('/convert-cookie-to-token', (req, res) => {
  const sessionId = req.cookies['sid']; // जो cookie नाम है (उदा. sid)
  if (!sessionId) return res.status(401).json({ error: 'No session cookie' });

  const session = SESSION_STORE[sessionId];
  if (!session) return res.status(401).json({ error: 'Invalid session' });

  // create JWT
  const payload = { sub: session.userId, uname: session.username };
  const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });

  // Send token to client (JSON response). Alternatively set as cookie/Authorization header.
  res.json({ access_token: token, token_type: 'Bearer', expires_in: 3600 });
});

app.listen(3000, () => console.log('running on :3000'));
