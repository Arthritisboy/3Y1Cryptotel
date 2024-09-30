const nodemailer = require('nodemailer');

//! DEVELOPMENT TESTING
const sendEmail = async (options) => {
  // ** 1.) Create a Transporter
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    auth: {
      user: process.env.EMAIL_USERNAME,
      pass: process.env.EMAIL_PASSWORD,
    },
  });

  // ** 2.) Define the email options
  const mailOptions = {
    from: 'Cryptotel <cryptotel@gmail.com>',
    to: options.email,
    subject: options.subject,
    text: options.message,
  };
  // ** 3.) Actually send the email
  await transporter.sendMail(mailOptions);
};

//! GMAIL
// const sendEmail = async (options) => {
//   // ** 1.) Create a Transporter
//   const transporter = nodemailer.createTransport({
//     service: 'gmail',
//     host: 'smtp.gmail.com',
//     port: 587,
//     auth: {
//       user: process.env.USER_EMAIL,
//       pass: process.env.USER_PASSWORD,
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

module.exports = sendEmail;
