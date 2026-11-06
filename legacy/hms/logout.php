<?php

session();
include 'include/config.php';

$patientId = (int) session()->get('id');

if ($patientId > 0) {
    hms_execute(
        $con,
        'UPDATE userlog
         SET logout = NOW()
         WHERE uid = ?
           AND status = 1
           AND logout IS NULL
         ORDER BY id DESC
         LIMIT 1',
        'i',
        array($patientId)
    );
}

session()->destroy();

header('Location: ' . rtrim(base_url(), '/') . '/', true, 302);
exit;
