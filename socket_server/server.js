const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();
const dotenv = require('dotenv');
const port = process.env.PORT || 3000;
const connectIO = require('./socket/socket');
const {connection} = require('./db/database');
const morgan = require('morgan');

dotenv.config();

const server = http.createServer(app);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(morgan('tiny'));

/// connect db
connection();

/// connext socket
connectIO(server);

/// routes
const userRoute = require('./routes/user_route');
const recentRoute = require('./routes/recent_route');
const messageRoute = require('./routes/message_route');

const v1 = process.env.API_URL;
app.use(`${v1}/users`, userRoute);
app.use(`${v1}/recents`, recentRoute);
app.use(`${v1}/messages`, messageRoute);

server.listen(port, () => {
  console.log('server Start', port);
});
