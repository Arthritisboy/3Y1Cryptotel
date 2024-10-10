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
    filename: function(req, file, cb) {
        cb(null, file.originalname)
    }
});
const upload = multer({ storage: storage });

const uploadEveryImage = async(req) => {
    return new Promise((resolve, reject) => {
        cloudinary.uploader.upload(req.file.path, {
            transformation: [
                { fetch_format: 'auto', quality: 'auto' },
                {
                    // width: 800,
                    // height: 600,
                    crop: 'fill',
                    gravity: 'auto',
                }
            ]
        }, (error, result) => {
            if (error) {
                console.error("Error uploading image:", error);
                reject(error);
            } else {
                console.log("Uploaded image URL:", result.secure_url);
                resolve(result.secure_url); // Ensure secure_url is returned
            }
        });
    });
};

const uploadProfileImage = async(req) => {
    return new Promise((resolve, reject) => {
        cloudinary.uploader.upload(req.file.path, {
            transformation: [
                { fetch_format: 'auto', quality: 'auto' },
                {
                    width: 300,
                    height: 300,
                    crop: 'fill',
                    gravity: 'auto',
                    radius: 'max',
                    background: 'none'
                }
            ]
        }, (error, result) => {
            if (error) {
                console.error("Error uploading image:", error);
                reject(error);
            } else {
                console.log("Uploaded image URL:", result.secure_url);
                resolve(result.secure_url); // Ensure secure_url is returned
            }
        });
    });
};



module.exports = { upload, cloudinary, generateTestUrl, uploadProfileImage, uploadEveryImage };