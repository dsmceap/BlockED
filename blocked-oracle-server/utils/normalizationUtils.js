function normalizeIfContainsLetter(value) {
    if (/[a-zA-Z]/.test(value)) {
        return value.toLowerCase();
    }
    return value;
}

function normalizeAll({ app_key, issue_auth, course_id, cert_id, user_id, lastname, firstname,
    recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
    badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
    badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
    general_context, general_type, general_id
 }) {
    return {
        app_key: normalizeIfContainsLetter(app_key),
        issue_auth: normalizeIfContainsLetter(issue_auth),
        course_id: normalizeIfContainsLetter(course_id),
        cert_id: normalizeIfContainsLetter(cert_id),
        user_id: normalizeIfContainsLetter(user_id),
        firstname: normalizeIfContainsLetter(firstname),
        lastname: normalizeIfContainsLetter(lastname),
        recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
        badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
        badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
        general_context, general_type, general_id
    };
}

module.exports = {
    normalizeAll
};
