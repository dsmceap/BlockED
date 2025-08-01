function generateDID(parts) {
    return `did:blocked/${parts.join('/')}`;
}

function buildCombinedDIDs({app_key, issue_auth, course_id, cert_id, user_id, lastname, firstname,
    recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
    badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
    badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
    general_context, general_type, general_id

}) {
    const cert_did = generateDID([app_key, issue_auth, course_id, cert_id]);
    const owner_did = generateDID([app_key, user_id, lastname, firstname]);
    
    const badge_did = generateDID([
        recipient_id, recipient_type, recipient_is_hashed, recipient_salt, badge_name, badge_critiria_id, 
        badge_issuer_name, badge_issuer_url, badge_issuer_email, badge_issuer_context, badge_issuer_id, badge_issuer_type,
        badge_context, badge_id, badge_type, badge_version, verify_type, verify_url, general_issued_on, general_evidence, 
        general_context, general_type, general_id
    ]);
    const combined_did = `${cert_did}/${owner_did}/${badge_did}`;
    return combined_did;
}

module.exports = {
    generateDID,
    buildCombinedDIDs
};
