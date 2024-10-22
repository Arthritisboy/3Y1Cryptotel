const { Parser } = require('json2csv');
const fs = require('fs');
const path = require('path');
const { mongoose } = require('../database/connection'); // Adjust the path accordingly

// Database and collection details
const databaseName = 'Cryptotel_Users';
const collectionName = 'ratings';

// Controller function to export the MongoDB collection as CSV
async function exportCollection(req, res) {
  try {
    // Check if mongoose is connected
    if (mongoose.connection.readyState !== 1) {
      return res.status(500).json({ message: 'Database is not connected.' });
    }

    const collection = mongoose.connection.db.collection(collectionName);

    // Fetch all documents from the collection
    const documents = await collection.find({}).toArray();

    // Check if there are any documents
    if (documents.length === 0) {
      return res.status(404).json({ message: 'No data found in the collection.' });
    }

    // Convert documents to CSV format
    const fields = Object.keys(documents[0]); // Get fields from the first document
    const json2csvParser = new Parser({ fields });
    const csv = json2csvParser.parse(documents);

    // Create the file path for the CSV file
    const filePath = path.join(__dirname, 'exported_data.csv');

    // Write CSV to a file
    fs.writeFileSync(filePath, csv);

    // Send the file as a downloadable response
    res.setHeader('Content-Disposition', 'attachment; filename=exported_data.csv');
    res.setHeader('Content-Type', 'text/csv');
    res.download(filePath, 'exported_data.csv', (err) => {
      if (err) {
        console.error('Error in file download:', err);
        res.status(500).json({ message: 'Failed to send the file.' });
      } else {
        console.log('CSV file sent successfully.');
      }
    });

  } catch (error) {
    console.error('Error exporting collection:', error);
    res.status(500).json({ message: 'Failed to export collection.' });
  }
}

module.exports = { exportCollection };
