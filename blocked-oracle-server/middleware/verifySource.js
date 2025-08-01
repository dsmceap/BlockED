require('dotenv').config();

function verifyMoodleSource(req, res, next) {
    const clientHeader = req.headers['x-blocked-client'];
    if (clientHeader !== 'moodle') {
        return res.status(400).json({ message: 'Invalid client header' });
    }

    const tokenHeader = req.headers['x-api-token'];
    if (tokenHeader !== process.env.MOODLE_API_TOKEN) {
        return res.status(400).json({ message: 'Invalid API token' });
    }

    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Basic ')) {
        return res.status(401).json({ message: 'Missing or invalid Authorization header' });
    }

    const base64Credentials = authHeader.split(' ')[1];
    const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
    const [username, password] = credentials.split(':');

    const validUser = process.env.MOODLE_API_USERNAME;
    const validPass = process.env.MOODLE_API_PASSWORD;

    if (username !== validUser || password !== validPass) {
        return res.status(401).json({ message: 'Invalid Basic Auth credentials' });
    }

    next();
}

function verifyClientSource(req, res, next) {
    const clientHeader = req.headers['x-blocked-client'];
    if (clientHeader !== 'client') {
        return res.status(400).json({ message: 'Invalid client header' });
    }

    const tokenHeader = req.headers['x-api-token'];
    if (tokenHeader !== process.env.CLIENT_API_TOKEN) {
        return res.status(400).json({ message: 'Invalid API token' });
    }

    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Basic ')) {
        return res.status(401).json({ message: 'Missing or invalid Authorization header' });
    }

    const base64Credentials = authHeader.split(' ')[1];
    const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
    const [username, password] = credentials.split(':');

    const validUser = process.env.CLIENT_API_USERNAME;
    const validPass = process.env.CLIENT_API_PASSWORD;

    if (username !== validUser || password !== validPass) {
        return res.status(401).json({ message: 'Invalid Basic Auth credentials' });
    }
    next();
}

function verifyAdminSource(req, res, next) {
    const clientHeader = req.headers['x-blocked-client'];
    if (clientHeader !== 'admin') {
        return res.status(400).json({ message: 'Invalid admin header' });
    }

    const tokenHeader = req.headers['x-api-token'];
    if (tokenHeader !== process.env.ADMIN_API_TOKEN) {
        return res.status(400).json({ message: 'Invalid API token' });
    }

    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Basic ')) {
        return res.status(401).json({ message: 'Missing or invalid Authorization header' });
    }

    const base64Credentials = authHeader.split(' ')[1];
    const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
    const [username, password] = credentials.split(':');

    const validUser = process.env.ADMIN_API_USERNAME;
    const validPass = process.env.ADMIN_API_PASSWORD;

    if (username !== validUser || password !== validPass) {
        return res.status(401).json({ message: 'Invalid Basic Auth credentials' });
    }
    next();
}

module.exports = { 
    verifyMoodleSource,
    verifyClientSource,
    verifyAdminSource
};
