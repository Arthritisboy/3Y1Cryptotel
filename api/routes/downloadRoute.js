const express = require('express');
const exportCsv = require('../controllers/downloadController');
const router = express.Router();

// Route to trigger CSV download
router.get('/', exportCsv.exportCollection);

module.exports = router;
