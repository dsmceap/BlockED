const express = require('express');
const router = express.Router();
const { getOracleAddress, getContractAddress } = require('../controllers/generalController');
const { verifyAdminSource } = require('../middleware/verifySource');

router.get('/oracle', verifyAdminSource, getOracleAddress);
router.get('/contract', verifyAdminSource, getContractAddress);

module.exports = router;