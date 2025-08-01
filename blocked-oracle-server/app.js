require('dotenv').config();
const { ensureWalletInEnv } = require('./utils/walletInit');
ensureWalletInEnv();

const express = require('express');
const certificateRoutes = require('./routes/certificateRoutes');
const generalRoutes = require('./routes/generalRoutes');

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/certificates', certificateRoutes);
app.use('/general', generalRoutes);

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
