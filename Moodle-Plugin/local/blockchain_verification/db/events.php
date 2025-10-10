<?php
defined('MOODLE_INTERNAL') || die();

$observers = [
    [
        'eventname'   => '\core\event\badge_awarded',
        'callback'    => '\local_blockchain_verification\observer::badge_awarded',
        // \plugintype_pluginname\event\observer\course_module_created::store',
        'priority'    => 9999,
    ],
];