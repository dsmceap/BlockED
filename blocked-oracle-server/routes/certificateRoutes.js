const express = require('express');
const router = express.Router();
const { issueCertificate, verifyCertificate, getHashedData } = require('../controllers/certificateController');
const { verifyMoodleSource, verifyClientSource } = require('../middleware/verifySource');

router.post('/issue', verifyMoodleSource, issueCertificate);
router.post('/verify', verifyClientSource, verifyCertificate);
router.get('/hash', verifyMoodleSource, getHashedData);

module.exports = router;
