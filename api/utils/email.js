const nodemailer = require('nodemailer');

// //! DEVELOPMENT TESTING
// const sendEmail = async (options) => {
//   // ** 1.) Create a Transporter
//   const transporter = nodemailer.createTransport({
//     host: process.env.EMAIL_HOST,
//     port: process.env.EMAIL_PORT,
//     auth: {
//       user: process.env.EMAIL_USERNAME,
//       pass: process.env.EMAIL_PASSWORD,
//     },
//   });

//   // ** 2.) Define the email options
//   const mailOptions = {
//     from: 'Cryptotel <cryptotel@gmail.com>',
//     to: options.email,
//     subject: options.subject,
//     text: options.message,
//   };
//   // ** 3.) Actually send the email
//   await transporter.sendMail(mailOptions);
// };

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
  if (options.type === 'verification') {
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
              <p style="font-size: 16px;">If you forgot your password, paste this token:</p>
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
