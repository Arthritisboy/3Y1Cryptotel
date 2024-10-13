const nodemailer = require('nodemailer');

//!GMAIL;
const sendEmail = async (options) => {
  // ** 1.) Create a Transporter
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    host: 'smtp.gmail.com',
    port: 587,
    auth: {
      user: process.env.USER_EMAIL,
      pass: process.env.USER_PASSWORD,
    },
  });
  // ** Message
  let message;

  if (options.type === 'booking') {
    if (options.bookingDetails.bookingType === 'HotelBooking') {
      const {
        fullName,
        hotelName,
        roomName,
        checkInDate,
        checkOutDate,
        totalPrice,
        status,
      } = options.bookingDetails;

      message = `
        <div style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
          <table style="border: 2px solid #4CAF50; border-radius: 5px; padding: 10px; max-width: 600px; margin: auto; border-collapse: collapse; background-color: #ffffff;">
            <tr>
              <td style="padding: 10px; text-align: center;">
                <h2 style="color: #4CAF50;">Booking Confirmation</h2>
                <p style="font-size: 16px;">Dear ${fullName},</p>
                <p>Thank you for booking with us. Your booking details are as follows:</p>
                <ul>
                  <li><strong>Hotel:</strong> ${hotelName}</li>
                  <li><strong>Room:</strong> ${roomName}</li>
                  <li><strong>Check-in Date:</strong> ${new Date(checkInDate).toLocaleDateString()}</li>
                  <li><strong>Check-out Date:</strong> ${new Date(checkOutDate).toLocaleDateString()}</li>
                  <li><strong>Total Price:</strong> ₱${totalPrice}</li>
                  <li><strong>Status:</strong> ${status === 'pending' ? 'Your booking is pending confirmation' : 'Confirmed'}</li>
                </ul>
                <p>We will notify you once your booking is confirmed. Thank you for choosing us!</p>
              </td>
            </tr>
          </table>
        </div>`;
    } else if (options.bookingDetails.bookingType === 'RestaurantBooking') {
      // Restaurant Booking Email
      const {
        fullName,
        restaurantName,
        tableNumber,
        checkInDate,
        checkOutDate,
        totalPrice,
        status,
      } = options.bookingDetails;

      message = `
        <div style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
          <table style="border: 2px solid #4CAF50; border-radius: 5px; padding: 10px; max-width: 600px; margin: auto; border-collapse: collapse; background-color: #ffffff;">
            <tr>
              <td style="padding: 10px; text-align: center;">
                <h2 style="color: #4CAF50;">Restaurant Booking Confirmation</h2>
                <p style="font-size: 16px;">Dear ${fullName},</p>
                <p>Thank you for booking a table with us. Your booking details are as follows:</p>
                <ul>
                  <li><strong>Status:</strong> ${status === 'pending' ? 'Your booking is pending confirmation' : 'Accepted'}</li>
                  <li><strong>Restaurant:</strong> ${restaurantName}</li>
                  <li><strong>Table Number:</strong> ${tableNumber}</li>
                  <li><strong>Check-in Date:</strong> ${new Date(checkInDate).toLocaleDateString()}</li>
                  <li><strong>Check-out Date:</strong> ${new Date(checkOutDate).toLocaleDateString()}</li>
                  <li><strong>Total Price:</strong> ₱${totalPrice}</li>
                </ul>
                <p>We will notify you once your booking is confirmed. Thank you for dining with us!</p>
              </td>
            </tr>
          </table>
        </div>`;
    }
  }

  // Email Verification Template
  if (options.type === 'verification') {
    console.log(options.verificationCode);
    message = `
      <div style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <table style="border: 2px solid #4CAF50; border-radius: 5px; padding: 10px; max-width: 600px; margin: auto; border-collapse: collapse; background-color: #ffffff;">
          <tr>
            <td style="padding: 10px; text-align: center;">
              <h2 style="color: #4CAF50;">Email Verification</h2>
              <p style="font-size: 16px;">Your verification code is:</p>
              <strong style="font-size: 20px; display: inline-block; padding: 10px; border: 2px solid #4CAF50; border-radius: 5px;">${options.verificationCode}</strong>
              <br>
              <p>This code is valid for 10 minutes.</p>
            </td>
          </tr>
        </table>
      </div>`;
  } else if (options.type === 'reset') {
    message = `
      <div style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <table style="border: 2px solid #4CAF50; border-radius: 5px; padding: 10px; max-width: 600px; margin: auto; border-collapse: collapse; background-color: #ffffff;">
          <tr>
            <td style="padding: 10px; text-align: center;">
              <h2 style="color: #4CAF50;">Password Reset</h2>
              <p style="font-size: 16px;">If you forgot your password, paste this code:</p>
              <strong style="font-size: 20px; display: inline-block; padding: 10px; border: 2px solid #4CAF50; border-radius: 5px;">${options.resetToken}</strong>
              <br>
              <p>If you didn't forget your password, please ignore this email!</p>
            </td>
          </tr>
        </table>
      </div>`;
  }

  // ** 2.) Define the email options
  const mailOptions = {
    from: 'Cryptotel <cryptotel@gmail.com>',
    to: options.email,
    subject: options.subject,
    text: options.message,
    html: message,
  };

  // ** 3.) Actually send the email
  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;
