const crypto = require('crypto');

function hashData(data, secretKeyword) {
    return crypto.createHmac('sha256', secretKeyword)
        .update(crypto.createHmac('sha256', secretKeyword)
            .update(data).digest('hex')).digest('hex');
}

module.exports = {
    hashData
};
