// const User = require('../models/User');
// const Hotel = require('../models/Hotel');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');


exports.getBooking = catchAsync(async (req, res, next) => {
    try {
        const publicId = 'cld-sample-2';
        console.log(publicId);
        res.status(200).json({ publicId });
    } catch (error) {

        return next(AppError('Error in get booking. Please try again.', 500),
        );
    }
});

exports.createBooking = catchAsync(async (req, res, next) => {
    try {

    } catch (error) {

        return next(AppError('Error in create booking. Please try again.', 500),
        );
    }
});

exports.updateBooking = catchAsync(async (req, res, next) => {
    try {

    } catch (error) {

        return next(AppError('Error in update booking. Please try again.', 500),
        );
    }
});

exports.deleteBooking = catchAsync(async (req, res, next) => {
    try {

    } catch (error) {

        return next(AppError('Error in delete booking. Please try again.', 500),
        );
    }
});