<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');
hms_flash('info', 'Spesialisasi dokter sekarang dikelola melalui Master Poli.');
hms_redirect('master-poli-jadwal.php');
