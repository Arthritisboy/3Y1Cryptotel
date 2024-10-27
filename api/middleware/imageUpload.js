require('dotenv').config({ path: './config.env' });
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const { v4: uuidv4 } = require('uuid'); // Import UUID library
const path = require('path');

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const generateTestUrl = (publicId) => {
  return cloudinary.url(publicId);
};

// Multer storage configuration
const storage = multer.diskStorage({
  filename: function (req, file, cb) {
    cb(null, file.originalname); // Maintain original filename
  },
});
const upload = multer({ storage: storage });

// Upload logic with conditional public_id for hotel and restaurant images
const uploadEveryImage = async (req, type) => {
  let publicId;

  // Assign unique public_id only for hotel or restaurant images
  if (type === 'hotel') {
    publicId = `hotels/${uuidv4()}`; // Unique public ID for hotel images
  } else if (type === 'restaurant') {
    publicId = `restaurants/${uuidv4()}`; // Unique public ID for restaurant images
  } else if (type === 'room') {
    publicId = `rooms/${uuidv4()}`;
  } else {
    publicId = `users/${path.basename(req.file.originalname, path.extname(req.file.originalname))}`; // Use original filename for user images
  }

  return new Promise((resolve, reject) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        public_id,
        transformation: [
          { fetch_format: 'auto', quality: 'auto' },
          {
            crop: 'fill',
            gravity: 'auto',
          },
        ],
      },
      (error, result) => {
        if (error) {
          console.error('Error uploading image:', error);
          reject(error);
        } else {
          console.log('Uploaded image URL:', result.secure_url);
          resolve(result.secure_url); // Ensure secure_url is returned
        }
      },
    );
  });
};

// Upload profile image with specific transformation
const uploadProfileImage = async (req) => {
  return new Promise((resolve, reject) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        transformation: [
          { fetch_format: 'auto', quality: 'auto' },
          {
            width: 300,
            height: 300,
            crop: 'fill',
            gravity: 'auto',
            radius: 'max',
            background: 'none',
          },
        ],
      },
      (error, result) => {
        if (error) {
          console.error('Error uploading image:', error);
          reject(error);
        } else {
          console.log('Uploaded image URL:', result.secure_url);
          resolve(result.secure_url); // Ensure secure_url is returned
        }
      },
    );
  });
};

module.exports = {
  upload,
  cloudinary,
  generateTestUrl,
  uploadProfileImage,
  uploadEveryImage,
};
