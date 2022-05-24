require("dotenv").config();
const AWS = require("aws-sdk");
const fs = require("fs");
const path = require("path");
const { nanoid } = require("nanoid");

const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_S3_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_S3_SECRET_ACCESS_KEY,
});

async function uploadImage(data) {
  fs.writeFileSync("upload.jpg", data, "binary", (err) => {
    if (!err) {
      console.log(`File created successfully!`);
    }
  });

  const image = path.join(__dirname, "/upload.jpg");
  const file = fs.readFileSync(image);

  const uploadedImage = await s3
    .upload({
      Bucket: process.env.AWS_BUCKET_NAME,
      Key: nanoid() + "_" + Date.now() + ".jpg",
      Body: file,
    })
    .promise();

  return uploadedImage.Location;
}

async function createBuffer() {
  const imagePath = path.join(__dirname, "/blob.jpg");
  const imageBuffer = fs.readFileSync(imagePath);

  uploadImage(imageBuffer);
}

module.exports = {
  uploadImage: uploadImage(),
};

// createBuffer();
// uploadImage(buffer);
