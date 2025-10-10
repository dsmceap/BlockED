<?php
/**
 * Database helper class for blockchain verification.
 *
 * @package    local_blockchain_verification
 * @copyright  2025 HT Apps
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace local_blockchain_verification;

defined('MOODLE_INTERNAL') || die();

class db_helper
{
    /**
     * Logs a message to a log file in the Moodle data directory.
     *
     * @param string $message The message to log.
     */
    private static function log($message) {
        global $CFG;
        $filepath = $CFG->dataroot . '/blockchain_verification_log.txt';
        file_put_contents($filepath, $message . PHP_EOL, FILE_APPEND);
    }

    /**
     * Retrieves the first name and last name of a user.
     *
     * @param int $user_id The ID of the user.
     * @return array An associative array containing 'firstname' and 'lastname' keys.
     */
    public static function get_name($user_id = 0)
    {
        global $DB;

        if (empty($user_id)) {
            return [];
        }

        $user = $DB->get_record('user', ['id' => $user_id], 'firstname, lastname');
        $firstname = $user->firstname;
        $lastname = $user->lastname;

        return ['firstname' => $firstname, 'lastname' => $lastname];
    }

    /**
     * Retrieves the certificate ID associated with a given course.
     *
     * @param int $course_id The ID of the course.
     * @return int The ID of the certificate or 0 if no certificate is found.
     */
    public static function get_certificate_id($course_id = 0)
    {
        if (empty($course_id)) {
            return 0;
        }

        global $DB;

        // Get the certificate instance associated with the course
        $cert = $DB->get_record('customcert', ['course' => $course_id], 'id', IGNORE_MISSING);
        if ($cert) {
            return $cert->id;
        }

        return 0;
    }

    /**
     * Retrieves the metadata of an issued badge.
     *
     * @param int $issued_badge_id The ID of the issued badge.
     * @return array An associative array containing the badge metadata.
     */
    public static function get_badge_metadata($issued_badge_id = 0)
    {
        if (empty($issued_badge_id)) {
            return [];
        }

        global $DB;

        $issued_badge = $DB->get_record('badge_issued', ['id' => $issued_badge_id]);
        if (!$issued_badge) {
            return [];
        }

        $hash = $issued_badge->uniquehash;

        // Use the Open Badges Backpack API to get the issued badge metadata from the hash
        $assertion = new \core_badges_assertion($hash, badges_open_badges_backpack_api());
        $badge_metadata = $assertion->get_badge_assertion(); // This is the Open Badges assertion array

        // The Blockchain Plugin Server requires a "duration_in_years" parameter for the request to successfully go through.
        // It must be calculated from the dates in the database.
        $dateissued = $issued_badge->dateissued;
        $dateexpire = $issued_badge->dateexpire;

        if (!isset($badge_metadata['issuedOn']) || empty($badge_metadata['issuedOn'])) {
            $badge_metadata['issuedOn'] = $dateissued;
        }

        if (!empty($dateexpire)) {
            // The difference in seconds between the two dates, divided by a year converted to seconds
            $duration_in_years_s = ($dateexpire - $dateissued) / (365 * 24 * 60 * 60);

            $duration_in_years = round($duration_in_years_s, 2);

            // If the duration is a whole number, convert it to an integer for cleaner display
            if ((int)$duration_in_years == $duration_in_years) {
                $duration_in_years = (int)$duration_in_years;
            }

            $badge_metadata['duration_in_years'] = $duration_in_years;
        }

        // If there's no expiration date, we can assume the badge is valid indefinitely. The Blockchain Plugin Server automatically sets the value to 60 years if not provided.

        return $badge_metadata;
    }

    /**
     * Saves data to the blockchain verification table.
     *
     * @param int $course_id The ID of the course.
     * @param int $user_id The ID of the user.
     * @param string $hash The unique hash associated with the certificate or badge.
     * @return bool True if the data was successfully saved, false if there were missing parameters.
     */
    public static function save_data_to_db($course_id = 0, $user_id = 0, $hash = '') {
        global $DB;

        if (empty($hash) || empty($course_id) || empty($user_id)) {
            error_log("BLOCKCHAIN PLUGIN --> Missing required parameter(s): hash, course_id, or user_id.");
            return false;
        }

        $record = new \stdClass();
        $record->hash = $hash;
        $record->course = $course_id;
        $record->userid = $user_id;

        $existing = $DB->get_record('blockchain_verification', ['hash' => $hash]);
        if ($existing) {
            // Hash already exists, no need to insert again
            return true;
        }

        $DB->insert_record('blockchain_verification', $record);

        return true;
    }

    /**
     * Retrieves the certificate hash for a given user and course.
     *
     * @param int $user_id The ID of the user.
     * @param int $course_id The ID of the course.
     * @return string The hash associated with the user's certificate for the given course or an empty string if no record is found.
     */
    public static function get_certificate_hash($user_id = 0, $course_id = 0)
    {
        global $DB;

        if (empty($user_id) || empty($course_id)) {
            error_log("BLOCKCHAIN PLUGIN --> Missing required parameter(s): user_id or course_id.");
            return '';
        }

        // Get the certificate issue record
        $issues = $DB->get_records('customcert_issues', ['userid' => $user_id]);
        if (empty($issues)) {
            error_log("BLOCKCHAIN PLUGIN --> No certificate issue found for user_id: $user_id and course_id: $course_id.");
            return '';
        }
        $issues = array_values($issues);

        $certificate = $DB->get_record('customcert', ['course' => $course_id]);
        if (!$certificate) {
            error_log("BLOCKCHAIN PLUGIN --> No certificate found with course_id: " . $course_id);
            return '';
        }
        // We have both the certificate associated with the course and the certificates issues for the user. Now we need to find the issue that corresponds to this certificate.
        $issue = null;
        foreach ($issues as $iss) {
            if ($iss->customcertid == $certificate->id) {
                $issue = $iss;
                break;
            }
        }

        if (!$issue) {
            // There was no known issue for this user and course
            error_log("BLOCKCHAIN PLUGIN --> No certificate issue found for user_id: $user_id and course_id: " . $course_id);
            return '';
        }

        // Issue found! The certificate is valid for this user and course.

        // Look up the hash in the blockchain_verification table
        $record = $DB->get_record('blockchain_verification', ['course' => $certificate->course, 'userid' => $user_id]);

        if (!$record) {
            error_log("BLOCKCHAIN PLUGIN --> No blockchain verification record found for user_id: $user_id and course_id: " . $certificate->course);
            return '';
        }

        return $record->hash;
    }
}
