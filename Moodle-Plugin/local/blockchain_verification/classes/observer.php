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
 * Event observer for blockchain verification.
 *
 * @package    local_blockchain_verification
 * @copyright  2025 HT Apps
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace local_blockchain_verification;

defined('MOODLE_INTERNAL') || die();

require_once(__DIR__ . '/../../../config.php');
require_once($CFG->libdir . '/datalib.php');
require_once($CFG->libdir . '/badgeslib.php');
require_once(__DIR__ . '/blockchain_helper.php');

use local_blockchain_verification\blockchain_helper as Blockchain_Plugin_Server_Helper; 
use local_blockchain_verification\db_helper as DB_Helper;
// Blockchain Plugin Server helper

class observer {

    public static function badge_awarded(\core\event\badge_awarded $event) {

        $BPS_Helper = new Blockchain_Plugin_Server_Helper();

        // The badge_awarded event provides the following data:
        // - objectid: The ID of the badge awarded
        // - relateduserid: The ID of the user who received the badge
        // - courseid: The ID of the course in which the badge was awarded, if applicable
        // - other: Additional data, such as 'badgeissuedid' which is the ID of the issued badge record
        $event_data = $event->get_data();

        $course_id = $event_data['courseid'];
        $user_id = $event_data['relateduserid'];

        // Get the user's firstname and lastname
        $user_data = DB_Helper::get_name($user_id);
        list($firstname, $lastname) = [$user_data['firstname'], $user_data['lastname']];

        // We now need to find the Custom Certificate module in the course.
        // Start by searching for certificates associated to the course in question, if provided
        $cert_id = DB_Helper::get_certificate_id($course_id);
        if(empty($cert_id)) {
            error_log("No certificate found for course ID: " . $course_id);
            return;
        }

        // Prepare data inherent to the course/user
        $moodle_data = array(
            'course_id' => $course_id,
            'user_id' => $user_id,
            'firstname' => $firstname,
            'lastname' => $lastname,
            'cert_id' => $cert_id
        );

        $badgeissuedid = $event_data['other']['badgeissuedid'];

        $badge_metadata = DB_Helper::get_badge_metadata($badgeissuedid);

        // Merge the basic Moodle data I initialised earlier with the badge metadata
        $merged_data = array_merge($badge_metadata, $moodle_data);

        
        // Convert everything to the blockchain schema
        $input_data = $BPS_Helper->convert_badge_to_blockchain_schema($merged_data);

        $hash = $BPS_Helper->send_to_blockchain($input_data);

        if(!$hash) {
            error_log("BLOCKCHAIN PLUGIN ERROR --> No hash returned from BPS.");
            return;
        }

        // Log the transaction in our custom table
        DB_Helper::save_data_to_db($course_id, $user_id, $hash);
    }
}