# Blockchain Certificate Verification Plugin

## Overview
This plugin adds blockchain verification capabilities to Moodle certificates. It provides a secure, tamper-proof way to verify microcredential authenticity using blockchain technology.

## Project Note
**For project demonstration purposes, this repository includes the CustomCert plugin (version 4.4.6) with slight modifications to showcase the blockchain verification functionality.**

The modifications are minimal and only affect the QR code generation to integrate with blockchain verification. This allows users to easily test and evaluate the blockchain features without complex setup procedures.

### CustomCert Modifications Made
The following file was modified for project demonstration:
- **File**: `mod/customcert/element/qrcode/classes/element.php`
- **Purpose**: Enable blockchain verification for certificate QR codes
- **Changes**: Added a function call to check for blockchain verification before falling back to standard verification
- **Impact**: QR codes now use blockchain-returned hashes when available, with graceful fallback to original functionality in case of failure

These modifications are provided as part of the project demonstration and can be easily applied to any CustomCert installation using the provided patch file.

## Installation
1. Download and install the `local_blockchain_verification` plugin
2. Run the Moodle upgrade process
3. Configure blockchain settings in Site Administration


## CustomCert Integration (Optional)
### Why Manual Integration is Required
The CustomCert plugin doesn't provide hooks for modifying QR code URLs, so a small modification is needed to enable blockchain verification for CustomCert QR codes.

### Integration Process

#### Option A: Apply Patch File
```bash
cd /path/to/moodle
patch -p1 < local/blockchain_verification/patches/customcert_integration.patch
```

#### Option B: Manual Integration
1. Open `mod/customcert/element/qrcode/classes/element.php`
2. Find the `render()` method (around line 165)
3. Locate this code:
```php
$qrcodeurl = new \moodle_url('/mod/customcert/verify_certificate.php', $urlparams);
$qrcodeurl = $qrcodeurl->out(false);
```

4. Replace it with:
```php
// Blockchain verification integration
if (class_exists('local_blockchain_verification\db_helper') && 
    class_exists('local_blockchain_verification\blockchain_helper')) {
    
    $qrcodeurl = \local_blockchain_verification\db_helper::get_certificate_hash($user->id, $issue->course);
    
    $B_Helper = new \local_blockchain_verification\blockchain_helper();
    $verified = $B_Helper->verify_hash($qrcodeurl);
        
    if(!$verified) {
        // If the hash is not verified, fallback to the standard Certificate verification URL
        $qrcodeurl = new \moodle_url('/mod/customcert/verify_certificate.php', $urlparams);
        $qrcodeurl = $qrcodeurl->out(false);
    }
} else {
    // Standard verification fallback (original behavior)
    $qrcodeurl = new \moodle_url('/mod/customcert/verify_certificate.php', $urlparams);
    $qrcodeurl = $qrcodeurl->out(false);
}
```

### How It Works

#### 1. Microcredential Issuance
- When a badge is issued, the system first checks if:
    - the badge is connected to a course
    - the course has a certificate
- If both conditions are met, it sends the badge metadata to the Blockchain Plugin Server (BPS).
- If the blockchain response is successful, the latter will return a hash that is subsequently stored in the platform's database

#### 2. Certificate Verification
- When a certificate is viewed, the modified CustomCert code checks for a blockchain hash in the database. The hash must be associated with both the user and the course.
- If blockchain verification is available and successful - and if a QR code is generated - the QR code's contents will consist of the stored hash.
- This will allow the Verifier Application to verify the certificate's authenticity on the blockchain.
- If blockchain verification fails or isn't available, it falls back to standard verification used by the Custom Certificate plugin.
- No changes to existing certificate functionality

### Maintenance
- The integration is minimal and should survive CustomCert updates
- If CustomCert updates break the integration, simply re-apply the modification
- The integration is completely optional - CustomCert works normally without it

### Uninstalling
To remove the integration, simply revert the changes to the CustomCert file or restore from backup.

## License
This plugin is licensed under the GNU General Public License v3.0 or later to maintain compatibility with Moodle.

**Copyright (C) 2025 HT Apps**

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

See the [LICENSE](LICENSE) file for the complete license text.

## Contributing
Contributions are welcome! Please ensure any contributions also follow the GPL v3+ licensing requirements.

## Support
This integration is designed to be safe and minimal. If you encounter issues:
1. Check that the blockchain verification plugin is properly installed
2. Verify that the CustomCert modification was applied correctly  
3. Check Moodle logs for any error messages