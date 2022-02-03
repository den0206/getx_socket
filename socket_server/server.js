const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();
const dotenv = require('dotenv');
const ngrok = require('ngrok');
const port = process.env.PORT || 3000;
const connectIO = require('./socket/socket');
const {connection} = require('./db/database');
const morgan = require('morgan');
const mongoSanitize = require('express-mongo-sanitize');
const helmet = require('helmet');
const {checkAPIKey} = require('./middleware/check_api');

dotenv.config();

const server = http.createServer(app);

// protect
app.use(mongoSanitize());
app.use(helmet());

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
const groupRoute = require('./routes/group_route');
const translateRoute = require('./routes/translate_route');

const v1 = process.env.API_URL;
const ngrokToken = process.env.NGROKTOKEN;

app.all(`${v1}/*`, checkAPIKey);
app.use(`${v1}/users`, userRoute);
app.use(`${v1}/recents`, recentRoute);
app.use(`${v1}/messages`, messageRoute);
app.use(`${v1}/groups`, groupRoute);
app.use(`${v1}/translate`, translateRoute);

server.listen(port, () => {
  console.log('server Start', port);
});

// ngrok.connect({addr: port, authtoken: ngrokToken, region: 'jp'}).then((url) => {
//   console.log(`Example app listening at ${url}`);
// });
