const Room = require('../models/Room');
const Hotel = require('../models/Hotel');
const AppError = require('../utils/appError');
const chalk = require('chalk');

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

            // Round the average rating to 1 decimal place
            hotel.averageRating = totalReviews > 0 ? parseFloat((totalRating / totalReviews).toFixed(1)) : 0.0;

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

module.exports = { updateAllHotelsAverage };
