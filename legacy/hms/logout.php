<?php
include_once __DIR__ . '/include/config.php';


// Hapus sesi aplikasi saat pengguna keluar.
$session = session();
$session->destroy();
if (function_exists('hms_clear_doctor_auth_cookie')) {
    hms_clear_doctor_auth_cookie();
}

// Kembalikan pengguna ke halaman utama SIMRS, bukan ke
// /dashboard/ milik XAMPP. Gunakan app.baseURL jika tersedia
// agar tetap sesuai dengan konfigurasi CodeIgniter.
$baseUrl = getenv('app.baseURL');
if (!$baseUrl) {
    $baseUrl = 'http://localhost:8080/hospital-sim/';
}
$baseUrl = rtrim($baseUrl, '/') . '/';

header('Location: ' . $baseUrl, true, 302);
exit;
