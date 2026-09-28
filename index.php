<?php
/**
 * CodeIgniter 4.7.4 front controller for XAMPP.
 * URL: http://localhost:8080/hospital/
 */
define('FCPATH', __DIR__ . DIRECTORY_SEPARATOR);
require FCPATH . 'app/Config/Paths.php';
$paths = new Config\Paths();
require rtrim($paths->systemDirectory, '\\/ ') . DIRECTORY_SEPARATOR . 'Boot.php';
exit(CodeIgniter\Boot::bootWeb($paths));
