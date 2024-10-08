const Room = require('../models/Room');
const Hotel = require('../models/Hotel');
const AppError = require('../utils/appError');
const chalk = require('chalk');

// Middleware to calculate and update the average price of rooms in a hotel
const calculateAveragePrice = async (req, res, next) => {
    const { hotelId } = req.params;

    try {
        console.log(chalk.blue(`Calculating average price for hotel ID: ${hotelId}`));

        // Find the hotel and populate its rooms
        const hotel = await Hotel.findById(hotelId).populate('rooms');

        if (!hotel) {
            console.log(chalk.red(`Hotel with ID: ${hotelId} not found`));
            return next(new AppError('Hotel not found with this ID.', 404));
        }

        console.log(chalk.green(`Found hotel: ${hotel.name} with ${hotel.rooms.length} rooms`));

        if (hotel.rooms.length === 0) {
            hotel.averagePrice = 0.0; // Set average price to 0.0 as a double
            console.log(chalk.yellow(`Hotel ${hotelId} has no rooms, setting average price to 0.0`));
        } else {
            // Calculate the average price of the rooms
            const totalPrice = hotel.rooms.reduce((sum, room) => {
                console.log(chalk.cyan(`Room ID: ${room._id}, Price: ${room.price}`));
                return sum + room.price;
            }, 0);

            hotel.averagePrice = parseFloat((totalPrice / hotel.rooms.length).toFixed(1)); // Round to 1 decimal place
        }

        // Ensure that the log always shows the price with a decimal (.0 for whole numbers)
        console.log(chalk.green(`Hotel ${hotelId} saved with updated average price: ${hotel.averagePrice.toFixed(1)}`));

        await hotel.save(); // Save the updated average price in the hotel
        next();
    } catch (error) {
        console.log(chalk.red(`Error calculating average price for hotel ${hotelId}:`, error));
        next(error);
    }
};

// Middleware to find a hotel by room ID and calculate the average rating
const calculateAverageRating = async (req, res, next) => {
    const { roomId } = req.params;

    if (!roomId) {
        console.log(chalk.red('Room ID is missing from the request parameters.'));
        return next(new AppError('Room ID is missing from the request parameters.', 400));
    }

    try {
        const room = await Room.findById(roomId);
        if (!room) {
            console.log(chalk.red(`Room not found with ID: ${roomId}`));
            return next(new AppError('Room not found', 404));
        }

        const hotel = await Hotel.findOne({ rooms: room._id });
        if (!hotel) {
            console.log(chalk.red(`No hotel found for room ID: ${roomId}`));
            return next(new AppError('No hotel found for this room ID.', 404));
        }

        console.log(chalk.green(`Found hotel: ${hotel.name} for room ID: ${roomId}`));

        let totalRating = 0;
        let totalReviews = room.ratings.length;

        room.ratings.forEach((rating) => {
            console.log(chalk.cyan(`Room ID: ${room._id}, Rating: ${rating.rating}`));
            totalRating += rating.rating;
        });

        hotel.averageRating = totalReviews > 0 ? parseFloat((totalRating / totalReviews).toFixed(1)) : 0.0; // Ensure it's a float

        // Ensure that the log shows the rating with one decimal point (.0 for whole numbers)
        console.log(chalk.magenta(`Calculated average rating for hotel ${hotel._id}: ${hotel.averageRating.toFixed(1)}`));

        req.hotel = hotel;
        next();
    } catch (error) {
        console.log(chalk.red(`Error calculating average rating for room ${roomId}:`, error));
        next(error);
    }
};

// Middleware to calculate and update the average price and rating for all hotels
const updateAllHotelsAverage = async (req, res, next) => {
    console.log(chalk.blue('Updating all hotels average price and rating'));

    try {
        const hotels = await Hotel.find().populate({
            path: 'rooms',
            populate: {
                path: 'ratings',
            },
        });
        console.log(chalk.green(`Found ${hotels.length} hotels to update`));

        for (const hotel of hotels) {
            console.log(chalk.cyan(`Processing hotel ID: ${hotel._id}`));

            // Calculate average price
            if (hotel.rooms.length === 0) {
                hotel.averagePrice = 0.0; // Set as double
                console.log(chalk.yellow(`Hotel ${hotel._id} has no rooms, setting average price to 0.0`));
            } else {
                const totalPrice = hotel.rooms.reduce((sum, room) => {
                    console.log(chalk.cyan(`Room ID: ${room._id}, Price: ${room.price}`));
                    return sum + room.price;
                }, 0);

                hotel.averagePrice = parseFloat((totalPrice / hotel.rooms.length).toFixed(1));
            }

            // Ensure that the log shows the price with a decimal
            console.log(chalk.green(`Hotel ${hotel._id} updated successfully with average price: ${hotel.averagePrice.toFixed(1)} and average rating: ${hotel.averageRating.toFixed(1)}`));

            // Calculate average rating
            let totalRating = 0;
            let totalReviews = 0;

            hotel.rooms.forEach((room) => {
                room.ratings.forEach((rating) => {
                    console.log(chalk.cyan(`Room ID: ${room._id}, Rating: ${rating.rating}`));
                    totalRating += rating.rating;
                    totalReviews++;
                });
            });

            hotel.averageRating = totalReviews > 0 ? parseFloat((totalRating / totalReviews).toFixed(1)) : 0.0; // Set to 0.0 if no ratings exist

            // Ensure that the log shows the rating with a decimal
            console.log(chalk.magenta(`Hotel ${hotel._id} total ratings: ${totalRating}, total reviews: ${totalReviews}, average rating: ${hotel.averageRating.toFixed(1)}`));

            await hotel.save();
            console.log(chalk.green(`Hotel ${hotel._id} updated successfully with average price: ${hotel.averagePrice} and average rating: ${hotel.averageRating}`));
        }

        res.status(200).json({
            status: 'success',
            message: 'Successfully updated average price and rating for all hotels.',
        });

    } catch (error) {
        console.log(chalk.red(`Error updating all hotels:`, error));
        next(new AppError(error.message, 500));
    }
};

module.exports = {
    calculateAveragePrice,
    calculateAverageRating,
    updateAllHotelsAverage,
};
