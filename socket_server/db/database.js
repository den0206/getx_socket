const mongoose = require('mongoose');

async function connection() {
  const name = process.env.DB_NAME;
  const password = process.env.DB_PASS;
  try {
    const dbUrl = `mongodb+srv://${name}:${password}@cluster0.cwoqr.mongodb.net/socket_flutter?retryWrites=true&w=majority`;
    await mongoose.connect(dbUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('SUccess DB');
  } catch (e) {
    console.log(e);
  }
}

function checkId(id) {
  return mongoose.isValidObjectId(id);
}
module.exports = {
  connection,
  checkId,
};
