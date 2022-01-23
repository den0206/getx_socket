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

async function uploadImage(file, message) {
  const extention = file.originalname.split('.').pop();
  const fileName = `${message.userId}/${message.id}/image${extention}`;

  const params = {Bucket: BUCKET_NAME, Key: `${fileName}`, Body: file.buffer};
  console.log(params);

  try {
    const command = new PutObjectCommand(params);
    const response = await s3Client.send(command);
    const fileUrl = getUrlFromBucket(params);
    return fileUrl;
  } catch (e) {
    console.log(error);
    throw new Error();
  }
}

async function deleteImage(filePath) {
  const params = {
    Bucket: BUCKET_NAME,
    Key: `${filePath}`,
  };

  try {
    const response = await s3.send(new DeleteObjectCommand(params));
    return response;
  } catch (e) {
    console.log(error);
    throw new Error();
  }
}

function getUrlFromBucket(params) {
  const {Bucket, Key} = params;
  return `https://${Bucket}.s3${REGION}.amazonaws.com/${Key}`;
}

module.exports = {uploadImage};
