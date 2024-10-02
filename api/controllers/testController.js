const Test = require('../models/Test');
const { upload, cloudinary, generateTestUrl } = require('../middleware/imageUpload');

const test = async (req, res) => {
    const publicId = 'cld-sample-2';
    const example = generateTestUrl(publicId);
    console.log(example);
    res.status(200).json({ example });
};


const getProfile = async (req, res) => {
    try {
        const profile = await Test.findById(req.params.id);
        if (!profile) {
            return res.status(404).json({ message: 'Profile not found' });
        }
        res.json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
};

const postProfile = (req, res) => {
    upload.single('image')(req, res, (err) => {
        if (err) {
            return res.status(500).json({
                success: false,
                message: "File upload error",
                error: err
            });
        }

        cloudinary.uploader.upload(req.file.path, {
            transformation: [
                {
                    fetch_format: 'auto',
                    quality: 'auto'
                },
                {
                    width: 300, // Set the width to make the image square
                    height: 300, // Set the height to make the image square
                    crop: 'fill',
                    gravity: 'auto',
                    radius: 'max' // This makes the image circular
                }
            ]
        }, async (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({
                    success: false,
                    message: "Error",
                    error: err
                });
            }

            try {
                // Save the image URL to the database
                const newProfile = new Test({
                    profile: result.secure_url
                });

                await newProfile.save();

                res.status(200).json({
                    success: true,
                    message: "Uploaded and saved!",
                    data: newProfile
                });
            } catch (dbError) {
                res.status(500).json({
                    success: false,
                    message: "Database error",
                    error: dbError
                });
            }
        });
    });
};

module.exports = {
    test,
    getProfile,
    postProfile
};
