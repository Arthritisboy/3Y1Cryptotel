// const { MongoClient } = require('mongodb');
// const mongoose = require('mongoose')
// const { Parser } = require('json2csv');
// const fs = require('fs');
// const path = require('path');

// // MongoDB URI and database/collection details
// const uri = "mongodb+srv://dbAdmin:<db_password>@cryptotel.6ajt0.mongodb.net/Crytotel_Users?retryWrites=true&w=majority&appName=Cryptotel;"
// const databaseName = 'Cryptotel_Users';
// const collectionName = 'ratings';

// // Controller function to export the MongoDB collection as CSV
// async function exportCollection(req, res) {
//   const client = new MongoClient(uri);

//   try {
//     // Connect to MongoDB
//     await client.connect();
//     console.log('Connected to MongoDB.');

//     const database = client.db(databaseName);
//     const collection = database.collection(collectionName);

//     // Fetch all documents from the collection
//     const documents = await collection.find({}).toArray();

//     // Convert documents to CSV format
//     const fields = Object.keys(documents[0]); // Get fields from the first document
//     const json2csvParser = new Parser({ fields });
//     const csv = json2csvParser.parse(documents);

//     // Create the file path for the CSV file
//     const filePath = path.join(__dirname, 'exported_data.csv');

//     // Write CSV to a file
//     fs.writeFileSync(filePath, csv);

//     // Send the file as a downloadable response
//     res.setHeader('Content-Disposition', 'attachment; filename=exported_data.csv');
//     res.setHeader('Content-Type', 'text/csv');
//     res.download(filePath, 'exported_data.csv', (err) => {
//       if (err) {
//         console.error('Error in file download:', err);
//       } else {
//         console.log('CSV file sent successfully.');
//       }
//     });

//   } catch (error) {
//     console.error('Error exporting collection:', error);
//     res.status(500).json({ message: 'Failed to export collection.' });
//   } finally {
//     // Close MongoDB connection
//     await client.close();
//   }
// }

// module.exports = { exportCollection };
