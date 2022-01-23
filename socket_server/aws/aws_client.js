const {
  GetObjectCommand,
  CreateBucketCommand,
  S3Client,
  PutObjectCommand,
  DeleteObjectCommand,
} = require('@aws-sdk/client-s3');

const dotEnv = require('dotenv');

dotEnv.config();

const BUCKET_NAME = process.env.AWS_BUCKET_NAME;
const ID = process.env.AWS_ID;
const SECRET = process.env.AWS_SECRET_KEY;
const REGION = process.env.AWS_S3_REGION;

const s3Client = new S3Client({
  region: REGION,
  credentials: {
    accessKeyId: ID,
    secretAccessKey: SECRET,
  },
});

async function uploadImage(file, fileName) {
  const params = {Bucket: BUCKET_NAME, Key: `${fileName}`, Body: file.buffer};

  try {
    const command = new PutObjectCommand(params);
    const response = await s3Client.send(command);
    const fileUrl = getUrlFromBucket(params);

    if (response.$metadata.httpStatusCode == 200) {
      return fileUrl;
    } else {
      throw new Error("Can't Update S3");
    }
  } catch (e) {
    console.log(error);
    throw new Error();
  }
}

async function deleteImage(urlString) {
  const url = new URL(urlString);
  const filePath = `${url.pathname.slice(1)}`;
  const params = {
    Bucket: BUCKET_NAME,
    Key: filePath,
  };

  try {
    const command = new DeleteObjectCommand(params);
    await s3Client.send(command);
  } catch (e) {
    console.log(error);
    throw new Error();
  }
}

function getUrlFromBucket(params) {
  const {Bucket, Key} = params;
  return `https://${Bucket}.s3.${REGION}.amazonaws.com/${Key}`;
}

module.exports = {uploadImage, deleteImage};
