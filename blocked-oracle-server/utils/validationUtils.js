const { ethers } = require('ethers');

function sanitizeDuration(duration_in_years) {
    const parsed = Number(duration_in_years);
    if (!parsed || isNaN(parsed) || parsed > 60) {
        console.warn('Invalid or missing durationInYears. Defaulting to 60.');
        return 60;
    }
    return parsed;
}

function sanitizeReceiverAddress(receiver_address) {
    if (!receiver_address || !ethers.utils.isAddress(receiver_address)) {
        console.warn('Invalid or missing receiverAddress. Using address(0).');
        return ethers.constants.AddressZero;
    }
    return receiver_address;
}

function sanitizeOptionalFields({duration_in_years, receiver_address}) {
    return {
        duration_in_years: sanitizeDuration(duration_in_years),
        receiver_address: sanitizeReceiverAddress(receiver_address)
    };
}

function isAlphanumeric(str, length) {
    return new RegExp(`^[a-z0-9]{${length}}$`).test(str);
}

function isDigits(str, length) {
    return new RegExp(`^\\d{${length}}$`).test(str);
}

function isDigitsBetween(str, min, max) {
    return new RegExp(`^\\d{${min},${max}}$`).test(str);
}

function isAlpha(str, min, max) {
    return new RegExp(`^[a-z]{${min},${max}}$`).test(str); // Already normalized to lowercase
}

function validateHashedData(hashed_data) {
    const isCorrectLength = hashed_data.length === 64;
    const isAlphanumeric = /^[a-zA-Z0-9]+$/.test(hashed_data);

    return isCorrectLength && isAlphanumeric;
}

function isLengthInRange(str, minLength, maxLength) {
    return typeof str === 'string' && str.length >= minLength && str.length <= maxLength;
}


function validateFields({ app_key, issue_auth, course_id, cert_id, user_id, lastname, firstname,
    recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
    badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
    badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
    general_context, general_type, general_id

 }) {
    const fieldLengthConfig = {
        app_key: [1, 200],
        issue_auth: [1, 200],
        course_id: [1, 200],
        cert_id: [1, 200],
        user_id: [1, 200],
        lastname: [1, 200],
        firstname: [1, 200],
        recipient_id: [1, 200],
        recipient_type: [1, 200],
        recipient_is_hashed: [1, 200],
        recipient_salt: [1, 200],
        badge_name: [1, 200],
        badge_critiria_id: [1, 200], 
        badge_issuer_name: [1, 200],
        badge_issuer_url: [1, 200],
        badge_issuer_email: [1, 200],
        badge_issuer_context: [1, 200],
        badge_issuer_id: [1, 200],
        badge_issuer_type: [1, 200],
        badge_context: [1, 200],
        badge_id: [1, 200],
        badge_type: [1, 200],
        badge_version: [1, 200],
        verify_type: [1, 200],
        verify_url: [1, 200],
        general_issued_on: [1, 200],
        general_evidence: [1, 200], 
        general_context: [1, 200],
        general_type: [1, 200], 
        general_id: [1, 200]
    };

    const fields = { app_key, issue_auth, course_id, cert_id, user_id, lastname, firstname,
        recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
        badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
        badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
        general_context, general_type, general_id
     };

    for (const [key, [min, max]] of Object.entries(fieldLengthConfig)) {
        if (!isLengthInRange(fields[key], min, max)) {
            return false;
        }
    }

    return true;
}

module.exports = {
    validateFields,
    sanitizeOptionalFields,
    validateHashedData
};
