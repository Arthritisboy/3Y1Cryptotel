require('dotenv').config({ path: './config.env' });
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const { v4: uuidv4 } = require('uuid');
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
    cb(null, file.originalname);
  },
});
const upload = multer({ storage: storage });

// Upload logic with type-based public_id
const uploadEveryImage = async (req, type) => {
  if (!req.file) {
    throw new Error('No file provided'); // Guard clause to check if file exists
  }

  console.log('File received:', req.file); // Debugging log for file details
  console.log('Upload type:', type); // Debugging log for type

  let publicId;

  // Assign unique public_id based on type
  switch (type) {
    case 'hotel':
      publicId = `hotels/${uuidv4()}`;
      break;
    case 'restaurant':
      publicId = `restaurants/${uuidv4()}`;
      break;
    case 'room':
      publicId = `rooms/${uuidv4()}`;
      break;
    case 'user':
    default:
      publicId = `users/${path.basename(req.file.originalname, path.extname(req.file.originalname))}`;
      break;
  }

  return new Promise((resolve, reject) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        public_id: publicId,
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
          resolve(result.secure_url);
        }
      },
    );
  });
};

// Upload profile image with specific transformation
const uploadProfileImage = async (req) => {
  if (!req.file) {
    throw new Error('No file provided'); // Guard clause
  }

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
          resolve(result.secure_url);
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
