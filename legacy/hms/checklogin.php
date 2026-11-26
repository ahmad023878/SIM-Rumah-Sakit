<?php
function check_login()
{
    if (!isset($_SESSION) || !isset($_SESSION['login']) || strlen((string) $_SESSION['login']) === 0) {
        if (function_exists('hms_get_patient_auth_cookie') && function_exists('hms_require_role')) {
            // The role guard verifies the signed cookie against the users table
            // and restores the session when it is still valid.
            if (hms_require_role('patient', 'user-login.php')) return true;
        }
        $host = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : 'localhost';
        header('Location: http://' . $host . '/hospital-sim-final-final/hms/user-login.php');
        exit;
    }
    return true;
}
