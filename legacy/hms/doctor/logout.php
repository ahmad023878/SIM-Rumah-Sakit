<?php
include_once __DIR__ . '/../include/config.php';

$session = session();
$session->destroy();
if (function_exists('hms_clear_doctor_auth_cookie')) {
    hms_clear_doctor_auth_cookie();
}

// Kembali ke halaman utama SIMRS melalui baseURL CodeIgniter.
header('Location: ' . rtrim(base_url(), '/') . '/', true, 302);
exit;
