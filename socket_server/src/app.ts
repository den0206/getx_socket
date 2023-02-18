import cors from 'cors';
import express, {Application} from 'express';
import helmet from 'helmet';
import http from 'http';
import nodeSchedule from 'node-schedule';
import checkAPIKey from './middleware/check_api';
import groupRoute from './resources/group/group.route';
import messageRoute from './resources/message/message.route';
import notificationRoute from './resources/notification/notification.route';
import recentRoute from './resources/recent/recent.route';
import reportRoute from './resources/report/report.route';
import tokenRoute from './resources/temp_token/temp_token.route';
import translateRoute from './resources/translate/translate.route';
import usersRoute from './resources/users/user.route';
import {connectDB} from './utils/database/database';
import {connectIO} from './utils/socket/socket';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const get = require('simple-get');

class App {
  public app: Application;
  public port: number;
  public server: http.Server;

  constructor(port: number) {
    this.app = express();
    this.port = port;
    this.server = http.createServer(this.app);

    this.initialiseMiddleware();
    this.initialiseRoutes();

    connectIO(this.server);
  }

  private initialiseMiddleware(): void {
    this.app.use(helmet());
    this.app.use(cors());
    this.app.use(express.json());
    this.app.use(express.urlencoded({extended: false}));
  }

  private initialiseRoutes(): void {
    this.app.get('/', (_: express.Request, res: express.Response) => {
      res.status(200).send('Success');
    });

    const apiVer = '/api/v1';
    this.app.all(`${apiVer}/*`, checkAPIKey);
    this.app.use(`${apiVer}/users`, usersRoute);
    this.app.use(`${apiVer}/recents`, recentRoute);
    this.app.use(`${apiVer}/messages`, messageRoute);
    this.app.use(`${apiVer}/groups`, groupRoute);
    this.app.use(`${apiVer}/translate`, translateRoute);
    this.app.use(`${apiVer}/notification`, notificationRoute);
    this.app.use(`${apiVer}/temptoken`, tokenRoute);
    this.app.use(`${apiVer}/report`, reportRoute);
  }

  private async initialiseDB(): Promise<void> {
    await connectDB();
  }

  public listen(): void {
    this.server.listen(this.port, async () => {
      await this.initialiseDB();
      this.setSchedule();
      console.log(`APP Listening ${this.port}`);
    });
  }

  private setSchedule(): void {
    const url = process.env.MAIN_URL;
    if (url) {
      console.log('Set Schedule');
      nodeSchedule.scheduleJob('01,16,25,41,50 * * * *', function () {
        get.concat(url, function (err: any, res: {statusCode: any}) {
          if (err) throw err;
          console.log(res.statusCode);
        });
      });
    }
  }
}

export default App;
