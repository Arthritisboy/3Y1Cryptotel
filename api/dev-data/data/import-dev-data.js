const fs = require('fs');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Student = require('./../../models/studentModel');

dotenv.config({ path: './config.env' });

const DB = process.env.DATABASE.replace(
  '<PASSWORD>',
  process.env.DATABASE_PASSWORD,
);

mongoose
  .connect(DB, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('DB connection successful!'));

// READ JSON DUMMY DATA
const tours = JSON.parse(
  fs.readFileSync(`${__dirname}/dummy_data.json`, 'utf-8'),
);

// IMPORT DATA INTO DB
const importData = async () => {
  try {
    await Student.create(tours);
    console.log('Data successfully loaded!');
  } catch (err) {
    console.log(err);
  }
  process.exit();
};

// DELETE ALL DATA FROM DB
const deleteData = async () => {
  try {
    await Student.deleteMany();
    console.log('Data successfully deleted!');
  } catch (err) {
    console.log(err);
  }
  process.exit();
};
console.log(process.argv);

// code node dev-data/data/import-dev-data.js --import
if (process.argv[2] === '--import') {
  importData();
  // code node dev-data/data/import-dev-data.js --delete
} else if (process.argv[2] === '--delete') {
  deleteData();
}
