const { hashData } = require('../utils/hashUtils');
const { validateFields, sanitizeOptionalFields, validateHashedData } = require('../utils/validationUtils');
const { normalizeAll } = require('../utils/normalizationUtils');
const { buildCombinedDIDs } = require('../utils/didCreationUtils');
const { issueCertificateOnChain,
        verifyCertificateOnChain,
        CERTIFICATE_IS_ACTIVE,
        CERTIFICATE_IS_INACTIVE,
        CERTIFICATE_DOES_NOT_EXIST } = require('../utils/blockchain');

const SECRET_KEYWORD = process.env.SECRET_KEYWORD;

exports.issueCertificate = async (req, res) => {
    let normalized_body = normalizeAll(req.body);

    const validated = validateFields(normalized_body);

    if (!validated) {
        return res.status(400).json({ message: 'Validation failed. Please check input formats.' });
    }

    const { duration_in_years, receiver_address } = sanitizeOptionalFields(req.body);

    const combined_did = buildCombinedDIDs(normalized_body);
    
    const hashed_data = hashData(combined_did, SECRET_KEYWORD);

    try {
        const issued = await issueCertificateOnChain(hashed_data, duration_in_years, receiver_address);

        if (issued) {
            return res.status(200).json({
                message: 'Certificate issued successfully',
                result: hashed_data
            });
        } else {
            return res.status(409).json({
                message: 'Certificate already issued',
                result: hashed_data
            });
        }
        
    } catch(err) {
        res.status(500).json({ message: 'Something went wrong'});
    }    
};

exports.verifyCertificate = async (req, res) => {

    const hashed_data = req.body.hashed_data;
    const validated = validateHashedData(hashed_data);

    if (!validated) {
        return res.status(400).json({ message: 'Validation failed. Please check input formats.' });
    }

    console.log("Hashed Data: ", hashed_data)

    try {
        const verified = await verifyCertificateOnChain(hashed_data);
        
        if (verified === CERTIFICATE_IS_ACTIVE) {
            return res.status(200).json({
                message: 'Verification was successful',
                result: true
            });
        } else if (verified === CERTIFICATE_IS_INACTIVE) {
            return res.status(200).json({
                message: 'Verification was successful',
                result: false
            });
        } else if (verified === CERTIFICATE_DOES_NOT_EXIST) {
            return res.status(409).json({
                message: 'Certificate does not exists',
                result: false
            });
        } else {
            res.status(500).json({ message: 'Something went wrong'});
        }

        
    } catch(err) {
        res.status(500).json({ message: 'Something went wrong'});
    }    
};

exports.getHashedData = (req, res) => {

    const requiredFields = ['app_key', 'issue_auth', 'course_id', 'cert_id', 'user_id', 'lastname', 'firstname',
        'recipient_id', 'recipient_type', 'recipient_is_hashed', 'recipient_salt', 'badge_name', 'badge_critiria_id', 
        'badge_issuer_name', 'badge_issuer_url', 'badge_issuer_email', 'badge_issuer_context', 'badge_issuer_id', 'badge_issuer_type',
        'badge_context', 'badge_id', 'badge_type', 'badge_version', 'verify_type', 'verify_url', 'general_issued_on', 'general_evidence', 
        'general_context', 'general_type', 'general_id'
    ];
    const missing = requiredFields.filter(key => !req.query[key]);

    if (missing.length > 0) {
        return res.status(400).json({ message: `Missing required query parameters: ${missing.join(', ')}` });
    }

    const normalized_query = normalizeAll(req.query);

    const validated = validateFields(normalized_query);
    if (!validated) {
        return res.status(400).json({ message: 'Validation failed. Please check input formats.' });
    }

    const combined_did = buildCombinedDIDs(normalized_query);
    const hashed_data = hashData(combined_did, SECRET_KEYWORD);

    return res.status(200).json({ hashed_data });
};
