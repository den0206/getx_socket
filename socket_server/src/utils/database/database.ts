import mongoose, {ConnectOptions} from 'mongoose';

export async function connectDB() {
  const {MONGO_USER, MONGO_PATH, MONGO_PASSWORD} = process.env;
  const dbUrl = `mongodb+srv://${MONGO_USER}:${MONGO_PASSWORD}@cluster0.cwoqr.mongodb.net/socket_flutter?retryWrites=true&w=majority`;

  try {
    const options: ConnectOptions = {dbName: MONGO_PATH};
    await mongoose.connect(dbUrl, options);
    console.log('Success connect DB');
  } catch (e) {
    console.log(e);
  }
}

export function checkMongoId(id: string): boolean {
  return mongoose.isValidObjectId(id);
}
