<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Language strings for the blockchain verification plugin.
 *
 * @package    local_blockchain_verification
 * @copyright  2025 HT Apps
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

$string['pluginname'] = 'Blockchain Certificate Verification';
$string['privacy:metadata'] = 'The blockchain verification plugin stores certificate hashes for verification purposes but does not store personal data directly.';

// Settings
$string['settings_heading'] = 'Blockchain Verification Settings';
$string['blockchain_server_url'] = 'Blockchain Server URL';
$string['blockchain_server_url_desc'] = 'The endpoint URL for your blockchain verification service';
$string['api_key'] = 'API Key';
$string['api_key_desc'] = 'Authentication key for blockchain service (if required)';
$string['verification_timeout'] = 'Verification Timeout';
$string['verification_timeout_desc'] = 'Maximum time to wait for blockchain verification (seconds)';

// Messages
$string['blockchain_verification_success'] = 'Certificate verified on blockchain';
$string['blockchain_verification_failed'] = 'Blockchain verification failed, using standard verification';
$string['blockchain_service_unavailable'] = 'Blockchain verification service unavailable';
