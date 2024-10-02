require('dotenv').config({ path: './config.env' });
const multer = require('multer');
const cloudinary = require('cloudinary').v2;

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

const generateTestUrl = (publicId) => {
  return cloudinary.url(publicId)
};

const storage = multer.diskStorage({
  filename: function (req,file,cb) {
    cb(null, file.originalname)
  }
});
const upload = multer({storage: storage});





module.exports = { upload, cloudinary, generateTestUrl };
