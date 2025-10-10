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
 * Blockchain helper class for certificate verification.
 *
 * @package    local_blockchain_verification
 * @copyright  2025 HT Apps
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace local_blockchain_verification;

defined('MOODLE_INTERNAL') || die();

class blockchain_helper
{

    private $base_url;
    private $app_key;
    private $issue_auth;

    private $issue_config;
    private $verify_config;
    private $hash_config;

    private $endpoints = [
        'issue' => 'issue',
        'verify' => 'verify',
        'get_cert_hash' => 'hash'
    ];

    /**
     * Constructor for the blockchain_helper class.
     * Initializes the class with configuration values from Moodle's $CFG object.
     */
    function __construct()
    {
        global $CFG;
        $this->base_url = $CFG->blockchain_url;
        $this->app_key = $CFG->blockchain_app_key;
        $this->issue_auth = $CFG->blockchain_issue_auth;
        $this->issue_config = [
            'username' => $CFG->blockchain_issue['username'],
            'password' => $CFG->blockchain_issue['password'],
            'headers' => $CFG->blockchain_issue['headers']
        ];

        $this->verify_config = [
            'username' => $CFG->blockchain_verify['username'],
            'password' => $CFG->blockchain_verify['password'],
            'headers' => $CFG->blockchain_verify['headers']
        ];

        $this->hash_config = [
            'username' => $CFG->blockchain_hash['username'],
            'password' => $CFG->blockchain_hash['password'],
            'headers' => $CFG->blockchain_hash['headers']
        ];
    }


    /**
     * Retrieves the configuration for a specific blockchain endpoint (issue, verify, hash).
     *
     * @param string $endpoint The endpoint to retrieve the configuration for ('issue', 'verify', 'hash').
     * @return array The configuration array including base URL, app key, authentication, and credentials.
     */
    public function get_config($endpoint)
    {
        $config_property = $endpoint . "_config";
        $endpoint_config = $this->$config_property;
        return array(
            'base_url' => $this->base_url,
            'app_key' => $this->app_key,
            'issue_auth' => $this->issue_auth,
            'username' => $endpoint_config['username'],
            'password' => $endpoint_config['password'],
            'headers' => $endpoint_config['headers']
        );
    }


    /**
     * Validates if the data is set and not empty, returning the default value if invalid.
     *
     * @param mixed $data The data to validate.
     * @param mixed $default_value The value to return if $data is empty or not set.
     * @return mixed The validated data or the default value.
     */
    private static function validate($data, $default_value)
    {
        return isset($data) && !empty($data) ? $data : $default_value;
    }


    /**
     * Constructs the headers required for the blockchain API request.
     *
     * @param array $config The configuration array containing authentication and header details.
     * @return array The headers for the cURL request.
     */
    private static function get_headers($config)
    {
        $data = [
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode($config['username'] . ':' . $config['password']),
            'X-Blocked-Client: ' . $config['headers']['X-Blocked-Client'],
            'X-API-Token: ' . $config['headers']['X-API-Token']
        ];

        return $data;
    }


    /**
     * Converts the badge metadata into the format required by the blockchain API.
     *
     * @param array $data The badge data to convert.
     * @return array The badge data converted to the blockchain format.
     */
    function convert_badge_to_blockchain_schema($data)
    {
        // Convert badge metadata to the format required by the blockchain
        $config = $this->get_config('issue');

        $recipient = $data['recipient'];
        $verify = $data['verify'] ?? [];
        $badge = $data['badge'];
        $issuer = $badge['issuer'];

        $schema = [
            'app_key' => $config['app_key'],
            'issue_auth' => $config['issue_auth'],
            'course_id' => (string)$data['course_id'],
            'user_id' => (string)$data['user_id'],
            'cert_id' => (string)$data['cert_id'],
            'firstname' => $data['firstname'],
            'lastname' => $data['lastname'],
            'recipient_id' => $recipient['identity'],
            'recipient_type' => $recipient['type'],
            'recipient_is_hashed' => ($recipient['hashed'] ?? false) ? 'true' : 'false', // If the recipient identity is not hashed, this parameter may not exist - in which case it must be 'false'
            'recipient_salt' => self::validate($recipient['salt'] ?? '', 'none'), // Same reason as above
            'badge_name' => $badge['name'],
            'badge_critiria_id' => $badge['criteria']['id'],
            'badge_issuer_name' => $issuer['name'],
            'badge_issuer_url' => $issuer['url'],
            'badge_issuer_email' => self::validate($issuer['email'] ?? '', 'none'), // This will likely be exist but be empty
            'badge_issuer_context' => $issuer['@context'],
            'badge_issuer_id' => $issuer['id'],
            'badge_issuer_type' => $issuer['type'],
            'badge_context' => $badge['@context'],
            'badge_id' => $badge['id'],
            'badge_type' => $badge['type'],
            'badge_version' => self::validate($badge['version'] ?? '', '1.0'),
            'verify_type' => self::validate($verify['type'] ?? '', 'none'),
            'verify_url' => self::validate($verify['url'] ?? '', 'none'),
            'general_issued_on' => self::validate($data['issuedOn'] ?? '', 'none'),
            'general_evidence' => self::validate($data['evidence'] ?? '', 'none'),
            'general_context' => self::validate($data['@context'] ?? '', 'none'),
            'general_type' => self::validate($data['type'] ?? '', 'none'),
            'general_id' => self::validate($data['id'] ?? '', 'none'),
        ];

        if (isset($data['duration_in_years']) && !empty($data['duration_in_years'])) {
            $schema['duration_in_years'] = $data['duration_in_years'];
        }

        return $schema;
    }


    /**
     * Sends the data to the blockchain for certificate issuance.
     *
     * @param array $data The certificate data to send to the blockchain.
     * @return mixed The result of the blockchain API request or null in case of error.
     */
    public function send_to_blockchain($data)
    {
        $ENDPOINT = $this->get_endpoint('issue');

        $config = $this->get_config($ENDPOINT);

        $headers = self::get_headers($config);

        $url = $config['base_url'] . $ENDPOINT;
        // Send the data to the blockchain API


        $curl_config = [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => $headers,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($data)
        ];

        try {
            $ch = curl_init($url);

            curl_setopt_array($ch, $curl_config);

            $response = curl_exec($ch);
            $status_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            if ($error) {
                error_log("cURL Error: $error");
            }
            curl_close($ch);

            $result = json_decode($response, true);
        } catch (\Exception $e) {
            error_log("cURL initialization failed: " . $e->getMessage());

            // Chiudi la cURL in caso di errore
            if (isset($ch)) {
                curl_close($ch);
            }
            return null;
        }
        switch ($status_code) {
            case 200:
            case 201:
                if (isset($result['result']) && !empty($result['result'])) {
                    return $result['result'];
                } else {
                    error_log("BLOCKCHAIN PLUGIN RESPONSE --> Success but no result found.");
                    return null;
                }
                break;
            case 400:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Bad Request: " . ($result['message'] ?? 'Unknown error'));
                break;
            case 401:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Unauthorized: Check your credentials.");
                break;
            case 403:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Forbidden: You don't have permission to access this resource.");
                break;
            case 404:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Not Found: The requested resource could not be found.");
                break;
            case 500:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Internal Server Error: " . ($result['message'] ?? 'Unknown error'));
                break;
            default:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Unexpected HTTP status code: $status_code");
                error_log("Response: " . print_r($response, true));
                break;
        }

        return $result;
    }


    /**
     * Verifies the given hash with the blockchain.
     *
     * @param string|null $hash The hash to verify.
     * @return mixed The result of the verification or false if invalid.
     */
    public function verify_hash($hash = null)
    {
        if (empty($hash)) {
            return false;
        } else if (!is_string($hash) || strlen($hash) !== 64 || !ctype_xdigit($hash)) {
            return false;
        }

        // $hash = "83a538bdc4b6118b6e177cbc53fb5c6cdbfa3b1d0250953a5c95a850ca357eae"; // Testing

        $ENDPOINT = $this->get_endpoint('verify');

        $config = $this->get_config($ENDPOINT);
        $headers = self::get_headers($config);


        $url = $config['base_url'] . $ENDPOINT;


        $data = json_encode(['hashed_data' => $hash]);

        $curl_config = [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => $headers,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $data
        ];

        try {
            $ch = curl_init($url);

            curl_setopt_array($ch, $curl_config);

            $response = curl_exec($ch);
            $status_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            if ($error) {
                error_log("cURL Error: $error");
            }
            curl_close($ch);

            $result = json_decode($response, true);
        } catch (\Exception $e) {
            error_log("cURL initialization failed: " . $e->getMessage());

            // Chiudi la cURL in caso di errore
            if (isset($ch)) {
                curl_close($ch);
            }
        }
        switch ($status_code) {
            case 200:
            case 201:
                if (isset($result['result']) && !empty($result['result'])) {
                    return $result['result'];
                } else {
                    error_log("BLOCKCHAIN PLUGIN RESPONSE --> Success but no result found.");
                    return false;
                }
                break;
            case 400:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Bad Request: " . ($result['message'] ?? 'Unknown error'));
                return false;
            case 401:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Unauthorized: Check your credentials.");
                return false;
            case 403:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Forbidden: You don't have permission to access this resource.");
                return false;
            case 404:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Not Found: The requested resource could not be found.");
                return false;
            case 500:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Internal Server Error: " . ($result['message'] ?? 'Unknown error'));
                return false;
            default:
                error_log("BLOCKCHAIN PLUGIN RESPONSE --> Unexpected HTTP status code: $status_code");
                error_log("Response: " . print_r($response, true));
                return false;
        }
    }


    /**
     * Retrieves the appropriate endpoint URL based on the key.
     *
     * @param string $key The key corresponding to an endpoint (issue, verify, hash).
     * @return string|null The endpoint URL or null if the key is invalid.
     */
    private function get_endpoint($key)
    {
        $endpoint = $this->endpoints[$key] ?? null;
        return $endpoint;
    }


    /**
     * Retrieves the URL for the blockchain verification page.
     *
     * @return string The URL for the blockchain verification page.
    */
    public static function get_blockchain_url()
    {
        global $CFG;
        $url = $CFG->wwwroot . '/local/blockchain_verification/index.php';
        return $url;
    }
}
