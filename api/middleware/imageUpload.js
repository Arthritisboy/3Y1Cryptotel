require('dotenv').config({ path: './config.env' });
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const { createHash } = require('crypto'); // Import crypto for hashing
const path = require('path');
const fs = require('fs');

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Multer storage configuration
const storage = multer.diskStorage({
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});
const upload = multer({ storage: storage });

// Helper function to generate a hash of the file
const generateFileHash = (filePath) => {
  const fileBuffer = fs.readFileSync(filePath);
  return createHash('md5').update(fileBuffer).digest('hex'); // Generate MD5 hash
};

// Check if the image already exists in Cloudinary
const imageExistsInCloudinary = async (fileHash) => {
  try {
    // Use the correct query syntax without unnecessary wildcards
    const result = await cloudinary.search
      .expression(`public_id="${fileHash}"`) // Exact match query
      .execute();

    return result.resources.length > 0; // If found, return true
  } catch (error) {
    console.error('Error checking image existence:', error);
    throw new Error('Failed to verify image uniqueness.');
  }
};

// Upload logic with duplicate image prevention
const uploadEveryImage = async (req, type) => {
  if (!req.file) {
    throw new Error('No file provided'); // Guard clause to check if file exists
  }

  console.log('File received:', req.file); // Debugging log for file details
  console.log('Upload type:', type); // Debugging log for type

  const fileHash = generateFileHash(req.file.path); // Generate hash of the file

  // Check if the image already exists in Cloudinary
  const exists = await imageExistsInCloudinary(fileHash);
  if (exists) {
    throw new Error(
      'This image has already been uploaded. Please use a different image.',
    );
  }

  // Generate public_id with the hash to ensure uniqueness
  const publicId = `${type}/${fileHash}`;

  return new Promise((resolve, reject) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        public_id: publicId,
        unique_filename: false, // Prevent Cloudinary from generating unique filenames
        overwrite: false, // Do not overwrite existing files
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

module.exports = {
  upload,
  cloudinary,
  uploadEveryImage,
};
